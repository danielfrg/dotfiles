c = get_config()

# The IP address the notebook server will listen on.
c.NotebookApp.ip = "127.0.0.1"

## Set the Access-Control-Allow-Origin header
#
#  Use "*" to allow any origin to access your server.
#
#  Takes precedence over allow_origin_pat.
c.NotebookApp.allow_origin = "*"

## Specify what command to use to invoke a web browser when opening the notebook.
#  If not specified, the default browser will be determined by the `webbrowser`
#  standard library module, which allows setting of the BROWSER environment
#  variable to override it.
c.NotebookApp.open_browser = False
c.NotebookApp.tornado_settings = {"debug": True}

c.NotebookApp.token = ""
c.LabApp.token = ""

# Tornado server settings
c.NotebookApp.tornado_settings = {
    "headers": {
        "Content-Security-Policy": "frame-ancestors *"  # Allows app to be iframed
    },
    "debug": True  # Auto restart
}

# ------------------------------------------------------------------------------
# s3contents development

# Tell Jupyter to use S3ContentsManager for storage
# from s3contents import S3ContentsManager
# c.NotebookApp.contents_manager_class = S3ContentsManager
# c.S3ContentsManager.endpoint_url = "http://localhost:9000"
# c.S3ContentsManager.access_key_id = "access-key"
# c.S3ContentsManager.secret_access_key = "secret-key"
# c.S3ContentsManager.bucket_name = "notebooks"

# from s3contents import GCSContentsManager
# c.NotebookApp.contents_manager_class = GCSContentsManager
# c.GCSContentsManager.project = "continuum-compute"
# c.GCSContentsManager.token = "~/.config/gcloud/application_default_credentials.json"
# c.GCSContentsManager.bucket = "gcsfs-test"
# c.GCSContentsManager.prefix = "this/is/the/prefix"

# c.NotebookApp.open_browser = False
# c.NotebookApp.tornado_settings = {"debug": True}
