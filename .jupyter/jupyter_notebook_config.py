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

c.LabApp.token = ""

# Tornado server settings
c.NotebookApp.tornado_settings = {
    "headers": {
        "Content-Security-Policy": "frame-ancestors *"  # Allows app to be iframed
    },
    "debug": True  # Auto restart
}

#######################################
# s3contents stuff
#######################################

# from s3contents import S3ContentsManager

# c.NotebookApp.contents_manager_class = S3ContentsManager
# c.S3ContentsManager.access_key_id = "access-key"
# c.S3ContentsManager.secret_access_key = "secret-key"
# c.S3ContentsManager.endpoint_url = "http://localhost:9000"
# c.S3ContentsManager.bucket = "notebooks"
# c.S3ContentsManager.prefix = "this/is/the/prefix"

# s3contents with HybridContentsManager
# from s3contents import S3ContentsManager
# from pgcontents.hybridmanager import HybridContentsManager
# from IPython.html.services.contents.filemanager import FileContentsManager

# c = get_config()

# c.NotebookApp.contents_manager_class = HybridContentsManager

# c.HybridContentsManager.manager_classes = {
#     # Associate the root directory with a PostgresContentsManager.
#     # This manager will receive all requests that don"t fall under any of the
#     # other managers.
#     "": S3ContentsManager,
#     # Associate /directory with a FileContentsManager.
#     "local_directory": FileContentsManager,
# }

# c.HybridContentsManager.manager_kwargs = {
#     # Args for root PostgresContentsManager.
#     "": {
#         "access_key_id": "access-key",
#         "secret_access_key": "secret-key",
#         "endpoint_url": "http://localhost:9000",
#         "bucket": "notebooks",
#     },
#     # Args for the FileContentsManager mapped to /directory
#     "local_directory": {
#         "root_dir": "/Users/danielfrg/Downloads",
#     },
# }
