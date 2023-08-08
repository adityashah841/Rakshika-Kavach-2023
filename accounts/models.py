from django.db import models

from django.contrib.auth.models import (AbstractBaseUser, BaseUserManager)
from rest_framework_simplejwt.tokens import RefreshToken

from django.conf import settings

# Create your models here.


class UserManager(BaseUserManager):

    def create_superuser(self,DOB, email, firstname, lastname,aadhar_number,phone_number, password=None, is_admin=True, is_staff=True):
        if not email:
            raise ValueError('Users must have an email address')
        if not aadhar_number:
            raise ValueError('Users must have an aadhar_number')
        if not phone_number:
            raise ValueError('Users must have an phone_number')

        user = self.model(
            email=self.normalize_email(email),
        )

        user.set_password(password)
        user.firstname = firstname
        user.lastname = lastname
        user.aadhar_number = aadhar_number
        user.phone_number = phone_number
        user.DOB = DOB
        user.admin = is_admin
        user.staff = is_staff
        user.is_active = True
        user.save(using=self._db)
        return user
        
    def create_staffuser(self, email, firstname, lastname,aadhar_number,phone_number,DOB, password):
        user = self.create_superuser(
            email,
            firstname,
            lastname,
            aadhar_number,
            phone_number,
            DOB,
            password=password
        )
        user.admin = False
        user.save(using=self._db)
        return user

    def create_user(self, email, username, firstname, lastname, password,aadhar_number,phone_number,gender,DOB, image, role):
        user = self.create_superuser(
            email,
            firstname,
            lastname,
            aadhar_number,
            phone_number,
            DOB,
            password=password
        )
        user.staff = False
        user.admin = False
        user.is_active = False
        user.username = username
        user.image = image
        user.save(using=self._db)
        return user

def upload_path_handler(instance, filename):
    return "images/profile/{label}/{file}".format(
        label=instance.firstname + '_' + instance.lastname, file=filename
    )

GENDER = (
    ('Male', 'Male'),
    ('Female', 'Female'),
    ('Admin','Admin')
)

class User(AbstractBaseUser):
    email             = models.EmailField(verbose_name='email address',max_length=255)
    username          = models.CharField(max_length=200,blank=True, null=True)
    firstname         = models.CharField(max_length=60)
    lastname          = models.CharField(max_length=60)
    gender            = models.CharField(max_length = 100,choices = GENDER, default = 'Female')
    aadhar_number     = models.DecimalField(max_digits = 12, decimal_places = 0,unique=True)
    phone_number      = models.DecimalField(max_digits = 10, decimal_places = 0,unique=True)
    image             = models.ImageField(upload_to = upload_path_handler,null = True, blank = True)
    DOB               = models.DateField()
    is_active         = models.BooleanField(default=False)
    staff             = models.BooleanField(default=False)
    admin             = models.BooleanField(default=False)

    USERNAME_FIELD = 'phone_number'

    REQUIRED_FIELDS = ['firstname', 'lastname', 'DOB','email','aadhar_number']

    objects = UserManager()

    def __str__(self):
        return str(self.username) + str(self.phone_number)

    def has_perm(self, perm, obj=None):
        return True

    def has_module_perms(self, app_label):
        return True

    @property
    def is_staff(self):
        return self.staff

    @property
    def is_admin(self):
        return self.admin

    def tokens(self):
        refresh = RefreshToken.for_user(self)
        return {
            'refresh': str(refresh),
            'access': str(refresh.access_token)
        }


GENDER = (
    ('Male', 'Male'),
    ('Female', 'Female'),
)

class DummyAadharInfo(models.Model):
    uid             = models.DecimalField(max_digits = 12, decimal_places = 0,unique=True)
    first_name      = models.CharField(max_length=100)
    last_name       = models.CharField(max_length=100)
    dob             = models.DateField()
    gender          = models.CharField(max_length = 100,choices = GENDER, default = 'Female')
    phone           = models.DecimalField(max_digits = 10, decimal_places = 0)
    email           = models.EmailField(verbose_name='email address',max_length=255)
    house_number    = models.CharField(max_length=100)
    locality        = models.CharField(max_length=100)
    landmark        = models.CharField(max_length=100)
    street          = models.CharField(max_length=100)
    district        = models.CharField(max_length=100)
    state           = models.CharField(max_length=100)
    pincode         = models.DecimalField(max_digits = 6, decimal_places = 0)

    def __str__(self):
        return str(self.uid)

# example
# uid=999971658847
# first name=Kumar 
# last name = Agarwal
# dob=04-05-1978
# dobt=A
# gender=M
# phone=2314475929
# email=kma@mailserver.com
# building=IPP, IAP
# landmark=Opp RSEB Window
# street=5A Madhuban
# locality=Veera Desai Road
# vtc=Udaipur
# district=Udaipur
# state=Rajasthan
# pincode=313001
LOCATION_TYPE = (
    ('Primary', 'Primary'),
    ('Secondary', 'Secondary'),
    ('Work', 'Work'),
    ('Home', 'Home'),
    ('Other', 'Other'),
)

class Address(models.Model):
    user            = models.ForeignKey(settings.AUTH_USER_MODEL,on_delete = models.CASCADE, related_name='user_address', null = True, blank=True)
    house_number    = models.CharField(max_length=100)
    locality        = models.CharField(max_length=100)
    landmark        = models.CharField(max_length=100)
    street          = models.CharField(max_length=100)
    district        = models.CharField(max_length=100)
    state           = models.CharField(max_length=100)
    pincode         = models.DecimalField(max_digits = 6, decimal_places = 0)
    type            = models.CharField(max_length = 100,choices = LOCATION_TYPE, default = 'Other')

    def __str__(self):
        return str(self.user.username) + '-' + str(self.id)
    

class EmergencyContact(models.Model):
    user            = models.ForeignKey(settings.AUTH_USER_MODEL,on_delete = models.CASCADE, related_name='user_emergency_contact', null = True, blank=True)
    name            = models.CharField(max_length=100)
    phone           = models.DecimalField(max_digits = 10, decimal_places = 0)
    relation        = models.CharField(max_length=100)

    def __str__(self):
        return str(self.user.username) + '-' + self.relation


class StateEmergencyContact(models.Model):
    state = models.CharField(max_length=200)
    numbers = models.TextField(max_length=100)

    def __str__(self):
        return self.state
