from django.shortcuts import render
from rest_framework_simplejwt.tokens import RefreshToken
from django.http.response import HttpResponse, JsonResponse
import jwt
from rest_framework.views import APIView
from rest_framework import (mixins, generics, status, permissions)
from django.contrib.auth import get_user_model
from .serializer import SendRequestSerializer, UserWarriorSerializer
from rest_framework.permissions import IsAuthenticated
from .models import UserWarrior
from decouple import config
# Create your views here.

import os
from twilio.rest import Client


# Find your Account SID and Auth Token at twilio.com/console
# and set the environment variables. See http://twil.io/secure
account_sid = config('TWILIO_ACCOUNT_SID')
auth_token = config('TWILIO_AUTH_TOKEN')
client = Client(account_sid, auth_token)


User = get_user_model()

class SendRequestView(generics.GenericAPIView):
    serializer_class = SendRequestSerializer
    permission_classes = [IsAuthenticated,]

    #get all my requests
    def get(self, request):
        try:
            user=User.objects.get(aadhar_number = request.user.aadhar_number)
        except User.DoesNotExist:
            content = {'detail': 'No such user exists'}
            return JsonResponse(content, status = status.HTTP_404_NOT_FOUND)
        if UserWarrior.objects.filter(user = user).exists():
            uw = UserWarrior.objects.filter(user = user, accept = False)
            recipeDetails = UserWarriorSerializer(uw, many=True, context={'request': request})
            return JsonResponse(recipeDetails.data, safe = False, status = status.HTTP_200_OK)
        content = {'detail': 'No request notification'}
        return JsonResponse(content, status = status.HTTP_404_NOT_FOUND)
                 
    #send a request
    def post(self, request):
        serializer = self.serializer_class(data=request.data)
        if serializer.is_valid():
            try:
                user=User.objects.get(aadhar_number = request.user.aadhar_number)
            except User.DoesNotExist:
                content = {'detail': 'No such user exists'}
                return JsonResponse(content, status = status.HTTP_404_NOT_FOUND)
            try:
                warrior=User.objects.get(phone_number = serializer.data['phone'])
            except:
                # message = client.messages \
                #     .create(
                #         messaging_service_sid=config('TWILIO_SERVICE_SID'),
                #         body='DOWNLOAD THE RAKSHIKA APP! YOUR ACQUITANCE WANTS TO MAKE YOU A WARRIOR',
                #         to='+919082230267'
                #     )
                # print(message.sid)
                content = {'detail': 'This warrior is not a user, sending message to join Rakshika'}
                return JsonResponse(content, status = status.HTTP_200_OK)
            UserWarrior.objects.create(
                user = user,
                warrior = warrior
            ) 
            content = {'detail': 'Request sent to warrior'}
            return JsonResponse(content, status = status.HTTP_200_OK)
        return JsonResponse(serializer.errors, status = status.HTTP_400_BAD_REQUEST) 
        
