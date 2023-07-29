from django.db import models
from accounts.models import User
from django.conf import settings
import os

def get_video_upload_to(instance, filename):
    return f'videos/{instance.user_id.id}/{filename}'

def get_audio_upload_to(instance, filename):
    return f'audios/{instance.user_id.id}/{filename}'

# Create your models here.
class Evidence(models.Model):
    id = models.AutoField(primary_key=True)
    user_id = models.ForeignKey(User, on_delete=models.CASCADE) # User name and parent's names are also required for filing a complaint
    timestamp = models.DateTimeField(auto_now_add=True)
    location = models.CharField(max_length=100) # Where the assault happened
    source = models.CharField(max_length=100) # The starting point of the girl's journey
    destination = models.CharField(max_length=100) # The planned destination
    planned_route = models.JSONField() # The route returned by the Maps API on frontend to the girl, which the girl was following
    # planned_route = models.CharField(max_length=100),
    isolated_zone_flag = models.BooleanField() # Whether the assault happened in an isolated zone
    authority_contacted = models.BooleanField() # Whether the authorities were contacted
    crime_type = models.CharField(max_length=100, default="Unknown") # The type of crime that happened
    action_taken = models.BooleanField() # Whether action was taken by the authorities
    action = models.CharField(max_length=100) # What action was taken by the authorities 
    action_taken_by = models.CharField(max_length=100) # Who took the action
    action_taken_timestamp = models.DateTimeField() # When the action was taken
    video = models.FileField(upload_to=get_video_upload_to)
    audio = models.FileField(upload_to=get_audio_upload_to)
    # action_taken = models.CharField(max_length=100)
    # action_taken_by = models.CharField(max_length=100)
    # action_taken_timestamp = models.DateTimeField(auto_now_add=True)
    # action_location = models.CharField(max_length=100)
    # video = models.URLField()
    # audio = models.URLField()

    def save(self, *args, **kwargs):
        super().save(*args, **kwargs)
        if self.video:
            filename = os.path.split(self.video.name)
            self.video.name = f'{filename[0]}/{filename[1]}'
        if self.audio:
            filename = os.path.split(self.audio.name)
            self.audio.name = f'{filename[0]}/{filename[1]}'
        super().save(update_fields=['video', 'audio'])

    def __str__ (self):
        return self.id

def get_image_upload_to(instance, filename):
        # Get the evidence_id from the instance
    evidence_id = instance.evidence.first().id
    # Return the desired upload path
    return f'suspects/{evidence_id}/{filename}'  

class Suspect(models.Model):
    # Note: This model DOES NOT store unique suspects, rather it records unique faces found.
    id = models.AutoField(primary_key=True)
    name = models.CharField(max_length=100, default='Unknown')
    image = models.ImageField(upload_to='suspects/', blank = True)
    evidence = models.ManyToManyField(Evidence, through='EvidenceSuspect')

class EvidenceSuspect(models.Model):
    evidence = models.ForeignKey(Evidence, on_delete=models.CASCADE)
    suspect = models.ForeignKey(Suspect, on_delete=models.CASCADE)

    class Meta:
        unique_together = ('evidence', 'suspect')