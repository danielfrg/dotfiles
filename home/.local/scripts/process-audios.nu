#!/usr/bin/env nu

def srt-to-md [srt_path: string] {
    let basename = ($srt_path | path basename)
    let name = ($basename | str replace ".srt" "")
    let date = ($name | split row " " | first)
    let md_path = (($srt_path | path dirname) | path join $"($name).md")
    let frontmatter = $"---\ndate: ($date)\n---\n\n"

    let body = (
        open --raw $srt_path
        | lines
        | where {|line|
            let t = ($line | str trim)
            $t != "" and (not ($t =~ '^[0-9]+$')) and (not ($t =~ '^\d{2}:\d{2}:\d{2},\d+\s+-->\s+\d{2}:\d{2}:\d{2},\d+$'))
        }
        | str join "\n"
    )

    $frontmatter + $body | save --force $md_path
    $md_path
}

def run-parakeet [parakeet_dir: string, audio_path: string] {
    let original_dir = (pwd)
    cd $parakeet_dir
    let result = (^uv run parakeet $audio_path | complete)
    cd $original_dir
    $result
}

def main [
    --input-dir: string = "~/Downloads/audios"
    --parakeet-dir: string = "~/code/parakeet-asr"
    --completed-dir: string = "~/Downloads/audios/completed"
] {
    let input_dir = ($input_dir | path expand)
    let parakeet_dir = ($parakeet_dir | path expand)
    let completed_dir = ($completed_dir | path expand)

    if not ($input_dir | path exists) {
        error make {msg: $"Input directory does not exist: ($input_dir)"}
    }

    if not ($parakeet_dir | path exists) {
        error make {
            msg: $"Parakeet directory does not exist: ($parakeet_dir). Pass --parakeet-dir with the correct path."
        }
    }

    mkdir $completed_dir

    let audio_exts = ["mp3" "m4a" "wav" "mp4" "aac" "flac" "ogg" "webm" "mov" "mkv" "aiff"]
    let audio_files = (
        ls $input_dir
        | where type == file
        | where {|f|
            let ext = ($f.name | path parse | get extension | default "" | str downcase)
            $ext in $audio_exts
        }
        | sort-by name
    )

    if ($audio_files | is-empty) {
        print $"No audio files found in ($input_dir)."
        return
    }

    mut processed = []
    mut failed = []

    for file in $audio_files {
        let audio_path = $file.name
        let parsed = ($audio_path | path parse)
        let srt_path = ($parsed.parent | path join $"($parsed.stem).srt")

        print $"Processing: ($audio_path | path basename)"
        let result = (run-parakeet $parakeet_dir $audio_path)

        if $result.exit_code != 0 {
            $failed = ($failed | append {
                file: $audio_path
                reason: "parakeet failed"
            })
            print $"  Failed: parakeet returned exit code ($result.exit_code)."
            continue
        }

        if not ($srt_path | path exists) {
            $failed = ($failed | append {
                file: $audio_path
                reason: "missing srt"
            })
            print $"  Failed: expected SRT not found at ($srt_path)."
            continue
        }

        let md_path = (try {
            srt-to-md $srt_path
        } catch {
            ""
        })

        if ($md_path == "") or (not ($md_path | path exists)) {
            $failed = ($failed | append {
                file: $audio_path
                reason: "md conversion failed"
            })
            print "  Failed: could not convert SRT to Markdown."
            continue
        }

        mv --force $audio_path $completed_dir
        mv --force $srt_path $completed_dir
        mv --force $md_path $completed_dir

        $processed = ($processed | append $audio_path)
        print $"  Done: moved audio, SRT, and Markdown to ($completed_dir)."
    }

    print ""
    print $"Completed: ($processed | length)"
    print $"Failed:    ($failed | length)"

    if not ($failed | is-empty) {
        print ""
        print "Failures:"
        $failed | each {|item| print $"  - ($item.file | path basename): ($item.reason)" }
    }
}
