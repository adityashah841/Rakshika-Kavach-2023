from django.db import models
from django.contrib.auth import get_user_model

# Create your models here.

User = get_user_model()

class UserWarrior(models.Model):
    user = models.ForeignKey(User,on_delete = models.CASCADE, related_name='user_warrior', null = True, blank=True)
    warrior = models.ForeignKey(User,on_delete = models.CASCADE, related_name='warrior', null = True, blank=True)
    accept = models.BooleanField(default=False)
    reject = models.BooleanField(default=False)
    created_at = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return str(self.user.phone_number)+'->'+str(self.warrior.phone_number)
    

class Notification(models.Model):
    user = models.ForeignKey(User,on_delete = models.CASCADE, related_name='user_notif', null = True, blank=True)
    user_notify = models.ForeignKey(User,on_delete = models.CASCADE, related_name='send_notif', null = True, blank=True)
    latitude = models.CharField(max_length=200)
    longitude = models.CharField(max_length=200)
    message = models.CharField(max_length=200, blank=True, null=True)
    accept = models.BooleanField(default=False)
    reject = models.BooleanField(default=False)
    created_at = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return self.user.username