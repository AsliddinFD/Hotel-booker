# Generated by Django 4.2.1 on 2024-01-04 10:18

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('core', '0010_booking_price'),
    ]

    operations = [
        migrations.AlterField(
            model_name='booking',
            name='ending_date',
            field=models.DateField(),
        ),
        migrations.AlterField(
            model_name='booking',
            name='starting_date',
            field=models.DateField(),
        ),
    ]
