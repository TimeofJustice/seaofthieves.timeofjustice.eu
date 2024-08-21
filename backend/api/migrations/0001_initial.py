# Generated by Django 5.1 on 2024-08-21 16:16

from django.db import migrations, models


class Migration(migrations.Migration):

    initial = True

    dependencies = [
    ]

    operations = [
        migrations.CreateModel(
            name='Page',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('path', models.CharField(max_length=255)),
                ('title', models.CharField(max_length=255)),
                ('views', models.IntegerField(default=0)),
            ],
        ),
    ]
