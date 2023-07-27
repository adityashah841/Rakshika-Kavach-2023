from rest_framework import serializers
from .models import *

class BlogSerializer(serializers.Serializer):
    id = serializers.IntegerField(read_only=True)
    title = serializers.CharField(max_length=100)
    content = serializers.CharField(max_length=100, required=False)
    author = serializers.CharField(max_length=100, required=False)
    created_at = serializers.DateTimeField(read_only=True)
    updated_at = serializers.DateTimeField(read_only=True)

    class Meta:
        # model = Blog
        fields = ['id','title','content','author','created_at','updated_at']