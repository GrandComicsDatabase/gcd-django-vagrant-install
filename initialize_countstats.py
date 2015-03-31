from apps.gcd.models.countstats import CountStats
from apps.gcd.models import Language, Country

if CountStats.objects.filter(language__isnull=False).count() == 0:
    for i in Language.objects.all():
        CountStats.objects.init_stats(language=i)

if CountStats.objects.filter(country__isnull=False).count() == 0:
    for i in Country.objects.all():
        CountStats.objects.init_stats(country=i)
