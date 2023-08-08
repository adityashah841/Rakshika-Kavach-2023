from rest_framework import serializers
from .models import UserWarrior


class SendRequestSerializer(serializers.Serializer):
    phone = serializers.CharField(max_length=10)

    class Meta:
        fields = ['phone']

class UserWarriorSerializer(serializers.ModelSerializer):
    user_name = serializers.SerializerMethodField()
    warrior_name = serializers.SerializerMethodField()

    class Meta:
        model = UserWarrior
        fields = ['id','user_name', 'warrior_name','accept']

    def get_user_name(self,obj):
        return obj.user.phone_number
    
    def get_warrior_name(self,obj):
        return obj.warrior.phone_number