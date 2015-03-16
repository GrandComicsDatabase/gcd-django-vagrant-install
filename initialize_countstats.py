from apps.gcd.models.countstats import CountStats
from apps.gcd.models import Language, Country

for i in Language.objects.all():
    CountStats.objects.init_stats(language=i)

for i in Country.objects.all():
    CountStats.objects.init_stats(country=i)
