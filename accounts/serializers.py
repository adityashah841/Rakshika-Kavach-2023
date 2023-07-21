from rest_framework import serializers


class AadharInfoSerializer(serializers.Serializer):
    aadhar_number = serializers.CharField(max_length=12)

    class Meta:
        fields = ['aadhar_number']


class PhoneVerificationSerializer(serializers.Serializer):
    code = serializers.CharField(max_length=8)
    aadhar_number = serializers.CharField(max_length=12)

    class Meta:
        fields = ['aadhar_number','code']
    