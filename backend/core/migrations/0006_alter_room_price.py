# Generated by Django 4.2.1 on 2024-01-03 09:59

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('core', '0005_room_number_of_beds_room_snacks'),
    ]

    operations = [
        migrations.AlterField(
            model_name='room',
            name='price',
            field=models.IntegerField(default=100),
        ),
    ]
