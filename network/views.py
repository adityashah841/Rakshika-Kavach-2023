from django.shortcuts import render
from rest_framework_simplejwt.tokens import RefreshToken
from django.http.response import HttpResponse, JsonResponse
import jwt
from rest_framework.views import APIView
from rest_framework import (mixins, generics, status, permissions)
from django.contrib.auth import get_user_model
from .serializer import SendRequestSerializer, UserWarriorSerializer, NotificationSerializer
from rest_framework.permissions import IsAuthenticated
from .models import UserWarrior, Notification
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
            uw = UserWarrior.objects.filter(user = user, accept = False, reject = False)
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
        

class AcceptWarriorRequestView(generics.GenericAPIView):
    permission_classes = [IsAuthenticated,]

    def post(self, request,pk):
        try:
            uw = UserWarrior.objects.get(warrior=request.user, id = pk, accept = False, reject = False) 
        except UserWarrior.DoesNotExist:
            content = {'detail': 'No such notification'}
            return JsonResponse(content, status = status.HTTP_404_NOT_FOUND)
        uw.accept = True
        uw.save()
        content = {'detail': 'Warrior accepted'}
        return JsonResponse(content, status = status.HTTP_200_OK)


class WarriorCountView(generics.GenericAPIView):
    permission_classes = [IsAuthenticated,]

    def post(self, request):
        try:
            user=User.objects.get(aadhar_number = request.user.aadhar_number)
        except User.DoesNotExist:
            content = {'detail': 'No such user exists'}
            return JsonResponse(content, status = status.HTTP_404_NOT_FOUND)
        
        warriors = UserWarrior.objects.filter(user=user,accept = True).count()
        volunteer = UserWarrior.objects.filter(warrior=user,accept = True).count()

        content =  {
            'warriors': (warriors),
            'volunteer': (volunteer)
        }
        return JsonResponse(content, status = status.HTTP_200_OK)
    

class SendNotificationView(generics.GenericAPIView):
    serializer_class = NotificationSerializer
    permission_classes = [IsAuthenticated,]

    #get all my requests
    def get(self, request,pk):
        try:
            user=User.objects.get(aadhar_number = request.user.aadhar_number)
        except User.DoesNotExist:
            content = {'detail': 'No such user exists'}
            return JsonResponse(content, status = status.HTTP_404_NOT_FOUND)
        if Notification.objects.filter(user_notify = user).exists():
            uw = Notification.objects.filter(user_notify = user, accept = False, reject = False)
            recipeDetails = NotificationSerializer(uw, many=True, context={'request': request})
            return JsonResponse(recipeDetails.data, safe = False, status = status.HTTP_200_OK)
        content = {'detail': 'No request notification'}
        return JsonResponse(content, status = status.HTTP_404_NOT_FOUND)
                 
    #send a request
    def post(self, request,pk):
        serializer = self.serializer_class(data=request.data)
        if serializer.is_valid():
            try:
                user=User.objects.get(aadhar_number = request.user.aadhar_number)
            except User.DoesNotExist:
                content = {'detail': 'No such user exists'}
                return JsonResponse(content, status = status.HTTP_404_NOT_FOUND)
            try:
                user1=User.objects.get(id = pk)
            except:
                content = {'detail': 'this user does not exist'}
                return JsonResponse(content, status = status.HTTP_404_NOT_FOUND)
            notif = Notification.objects.create(
                user = user,
                user_notify = user1,
                latitude = serializer.data['latitude'],
                longitude = serializer.data['longitude']
            ) 

            message = client.messages \
                .create(
                    messaging_service_sid=config('TWILIO_SERVICE_SID'),
                    body=f'you have a notification from {user.username}, location is https://www.google.com/maps?q=${notif.latitude},${notif.longitude}',
                    to='+919082230267'
                )
            print(message.sid)
            content = {'detail': 'location send to user'}
            return JsonResponse(content, status = status.HTTP_200_OK)
        return JsonResponse(serializer.errors, status = status.HTTP_400_BAD_REQUEST) 
    

    def delete(self, request,pk):
        try:
            blog = Notification.objects.get(id = pk)
        except Notification.DoesNotExist:
            content = {'detail': 'No such Notification exists'}
            return JsonResponse(content, status = status.HTTP_404_NOT_FOUND)
        blog.delete()
        content = {'detail': 'Notification Deleted'}
        return JsonResponse(content, status = status.HTTP_202_ACCEPTED)
        

class AcceptNotificationRequestView(generics.GenericAPIView):
    permission_classes = [IsAuthenticated,]

    def post(self, request,pk):
        try:
            uw = Notification.objects.get(user_notify=request.user, id = pk, accept = False, reject = False) 
        except Notification.DoesNotExist:
            content = {'detail': 'No such notification'}
            return JsonResponse(content, status = status.HTTP_404_NOT_FOUND)
        uw.accept = True
        uw.message = f"{request.user.username} is close and on the way, stay calm"
        uw.save()
        content = {'detail': 'Notification accepted'}
        return JsonResponse(content, status = status.HTTP_200_OK)
    
class NotifyUserRequestView(generics.GenericAPIView):
    permission_classes = [IsAuthenticated,]

    def get(self, request):
        try:
            user=User.objects.get(aadhar_number = request.user.aadhar_number)
        except User.DoesNotExist:
            content = {'detail': 'No such user exists'}
            return JsonResponse(content, status = status.HTTP_404_NOT_FOUND)
        print(Notification.objects.all())
        if Notification.objects.filter(user = user).exists():
            uw = Notification.objects.filter(user = user, accept = True)
            recipeDetails = NotificationSerializer(uw, many=True, context={'request': request})
            return JsonResponse(recipeDetails.data, safe = False, status = status.HTTP_200_OK)
        content = {'detail': 'No such notification'}
        return JsonResponse(content, status = status.HTTP_404_NOT_FOUND)