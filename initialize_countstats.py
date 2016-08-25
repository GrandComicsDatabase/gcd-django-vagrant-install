import django

from apps.stats.models import CountStats
from apps.stddata.models import Language, Country

django.setup()

if CountStats.objects.filter(language__isnull=False).count() == 0:
    for i in Language.objects.all():
        CountStats.objects.init_stats(language=i)

if CountStats.objects.filter(country__isnull=False).count() == 0:
    for i in Country.objects.all():
        CountStats.objects.init_stats(country=i)

CountStats.objects.init_stats()
