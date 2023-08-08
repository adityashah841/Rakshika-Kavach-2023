from django.db import models
from django.contrib.auth import get_user_model

# Create your models here.

User = get_user_model()

class UserWarrior(models.Model):
    user = models.ForeignKey(User,on_delete = models.CASCADE, related_name='user_warrior', null = True, blank=True)
    warrior = models.ForeignKey(User,on_delete = models.CASCADE, related_name='warrior', null = True, blank=True)
    accept = models.BooleanField(default=False)
    created_at = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return str(self.user.phone_number)+'->'+str(self.warrior.phone_number)