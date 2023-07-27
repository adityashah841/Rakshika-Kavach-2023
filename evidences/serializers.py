from rest_framework import serializers
from django.utils.dateparse import parse_datetime
from .models import *

class EvidenceSerializer(serializers.Serializer):
    id = serializers.IntegerField(read_only=True)
    user_id = serializers.PrimaryKeyRelatedField(queryset=User.objects.all(), required=True)
    timestamp = serializers.DateTimeField(read_only=True)
    location = serializers.CharField(max_length=100)
    source = serializers.CharField(max_length=100)
    destination = serializers.CharField(max_length=100)
    planned_route = serializers.JSONField()
    isolated_zone_flag = serializers.BooleanField()
    authority_contacted = serializers.BooleanField()
    action_taken = serializers.BooleanField()
    action = serializers.CharField(max_length=100)
    action_taken_by = serializers.CharField(max_length=100)
    action_taken_timestamp = serializers.DateTimeField()
    video = serializers.FileField(required=True)
    audio = serializers.FileField(required=True)

    def validate_action_taken_timestamp(self, value):
        if not parse_datetime(str(value)):
            raise serializers.ValidationError('Invalid date format')
        print(value)
        return value

    def create(self, validated_data):
        return Evidence.objects.create(**validated_data)

    class Meta:
        # model = Evidence
        fields = ['id', 'user_id', 'timestamp', 'location', 'source', 'destination', 'planned_route', 'isolated_zone_flag', 'authority_contacted', 'action_taken', 'action', 'action_taken_by', 'action_taken_timestamp', 'video', 'audio']

class SuspectSerializer(serializers.ModelSerializer):
    class Meta:
        model = Suspect
        fields = ['id', 'name', 'image']

class EvidenceSuspectSerializer(serializers.ModelSerializer):
    class Meta:
        model = EvidenceSuspect
        fields = ['evidence', 'suspect']