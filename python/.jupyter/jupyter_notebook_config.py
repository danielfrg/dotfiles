c = get_config()

# The IP address the notebook server will listen on.
c.ServerApp.ip = "127.0.0.1"

## Set the Access-Control-Allow-Origin header
#
#  Use "*" to allow any origin to access your server.
#
#  Takes precedence over allow_origin_pat.
c.ServerApp.allow_origin = "*"

## Specify what command to use to invoke a web browser when opening the notebook.
#  If not specified, the default browser will be determined by the `webbrowser`
#  standard library module, which allows setting of the BROWSER environment
#  variable to override it.
c.ServerApp.open_browser = False
c.ServerApp.tornado_settings = {"debug": True}
c.ServerApp.token = ""

# Tornado server settings
c.ServerApp.tornado_settings = {
    "headers": {
        "Content-Security-Policy": "frame-ancestors *"  # Allows app to be iframed
    },
    "debug": True,  # Auto restart
}


a = 1

a.__or__
# ------------------------------------------------------------------------------
# s3contents development

# Tell Jupyter to use S3ContentsManager for storage
# from s3contents import S3ContentsManager

# c.ServerApp.contents_manager_class = S3ContentsManager
# c.S3ContentsManager.bucket = "voltrondata-pixar"
# c.ServerApp.root_dir = ""

# S3contents MinIO
# c.ServerApp.contents_manager_class = S3ContentsManager
# c.S3ContentsManager.access_key_id = "Q3AM3UQ867SPQQA43P2F"
# c.S3ContentsManager.secret_access_key = "zuf+tfteSlswRu7BJ86wekitnifILbZam1KYY3TG"
# c.S3ContentsManager.endpoint_url = "https://play.minio.io:9000"
# c.S3ContentsManager.bucket = "s3contents-demo"
# c.S3ContentsManager.prefix = "notebooks/test"

# S3contents local MinIO
# from s3contents import S3ContentsManager

# c.ServerApp.contents_manager_class = S3ContentsManager
# c.S3ContentsManager.endpoint_url = "http://localhost:9000"
# c.S3ContentsManager.access_key_id = "access-key"
# c.S3ContentsManager.secret_access_key = "secret-key"
# c.S3ContentsManager.bucket = "notebooks"

# c.ServerApp.open_browser = False
# c.ServerApp.tornado_settings = {"debug": True}
