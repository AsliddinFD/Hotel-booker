from django.db import models
from django.contrib.auth.hashers import make_password
from  django.contrib.auth.models import AbstractBaseUser, BaseUserManager

class UserManager(BaseUserManager):
    def create_user(self, email, name, password=None, **extra_fields):
        if not email:
            raise ValueError('You must enter your email')
        user = self.model(email = self.normalize_email(email), name = name)
        user.set_password(password)
        user.save(using=self._db)
        return user

    def create_superuser(self, email, password=None, name=None, **extra_fields):
        # Note the corrected order of arguments
        user = self.create_user(email, name, password, **extra_fields)
        
        user.is_staff = True
        user.is_superuser = True
        user.save(using=self._db)
        return user


class User(AbstractBaseUser):
    name = models.CharField(max_length =255)
    email = models.CharField(max_length=255, unique = True)
    is_staff = models.BooleanField(default = False)
    objects = UserManager()
    USERNAME_FIELD='email'
    REQUIRED_FIELDS = ('name',)
    
    def has_perm(self, perm, obj=None):
        return True

    def has_module_perms(self, app_label):
        return True
    
    def save(self, *args, **kwargs):
        # Check if the password has been changed
        if self.password and not self.password.startswith(('pbkdf2_sha256$', 'bcrypt$', 'argon2')):
            self.password = make_password(self.password)

        super().save(*args, **kwargs)
        

class Room(models.Model):
    number = models.IntegerField()
    image = models.CharField(max_length=2000)
    is_booked = models.BooleanField(default=False)
    price = models.IntegerField(default=100)
    number_of_beds = models.IntegerField(default=1)
    number_of_restrooms = models.IntegerField(default=1)
    number_of_wardrobes = models.IntegerField(default=1)
    snacks = models.BooleanField(default=False)
    booking_start_date = models.DateField(null=True, blank=True)
    booking_end_date = models.DateField(null=True, blank=True)

class Booking(models.Model):
    room = models.ForeignKey(Room, on_delete=models.CASCADE)
    customer = models.ForeignKey(User, on_delete=models.CASCADE)
    price = models.IntegerField(default=100)
    is_cancelled = models.BooleanField(default=False)
    starting_date = models.DateField()
    ending_date = models.DateField()


