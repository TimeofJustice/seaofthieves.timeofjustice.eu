# Generated by Django 5.1 on 2024-08-21 21:04

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('api', '0003_column_remove_wiki_modules_alter_wiki_more_row_and_more'),
    ]

    operations = [
        migrations.AddField(
            model_name='column',
            name='amount',
            field=models.IntegerField(blank=True, null=True),
        ),
    ]
