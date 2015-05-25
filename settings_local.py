ADVERTISING = False
FAKE_COVER_IMAGES = False
DEBUG = True
BETA = False
DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.mysql',
        'NAME': 'gcd',
        'USER': 'root',
        'PASSWORD': 'gcd',
    }
}
CACHES = {
    'default': {
        'BACKEND': 'django.core.cache.backends.locmem.LocMemCache',
        'LOCATION': 'unique-snowflake'
    }
}
EMAIL_BACKEND = 'django.core.mail.backends.console.EmailBackend'

SITE_URL = 'http://localhost:8000/'
IMAGE_SERVER_URL = 'http://localhost:8000/site_media/'
MEDIA_URL = '/site_media/'
COVERS_DIR = '/img/gcd/covers_by_id/'
NEW_COVERS_DIR = '/img/gcd/new_covers/'

COMPRESS = True
COMPRESS_VERSION = True

