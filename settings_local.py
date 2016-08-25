from os.path import abspath, dirname, join


ADVERTISING = False
FAKE_COVER_IMAGES = False
DEBUG = True
BETA = False
DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.mysql',
        'NAME': 'gcd',
        'USER': 'gcd',
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

SITE_URL = 'http://192.168.63.30:8000/'
IMAGE_SERVER_URL = 'http://192.168.63.30:8000/media/'
COVERS_DIR = '/img/gcd/covers_by_id/'
NEW_COVERS_DIR = '/img/gcd/new_covers/'
VOTING_DIR = abspath(join(dirname(__file__), 'media/voting_receipts'))

COMPRESS = True
COMPRESS_VERSION = True
