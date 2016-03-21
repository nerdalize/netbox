import django_tables2 as tables
from django_tables2.utils import Accessor

from .models import Secret


#
# Secrets
#

class SecretTable(tables.Table):
    device = tables.LinkColumn('secrets:secret', args=[Accessor('pk')], verbose_name='Device')
    role = tables.Column(verbose_name='Role')
    name = tables.Column(verbose_name='Name')
    last_modified = tables.DateTimeColumn(verbose_name='Last modified')

    class Meta:
        model = Secret
        fields = ('device', 'role', 'name', 'last_modified')
        empty_text = "No secrets found."
        attrs = {
            'class': 'table table-hover',
        }


class SecretBulkEditTable(SecretTable):
    pk = tables.CheckBoxColumn()

    class Meta(SecretTable.Meta):
        model = None  # django_tables2 bugfix
        fields = ('pk', 'device', 'role', 'name')
