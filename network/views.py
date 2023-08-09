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
# from accounts.models import User
from accounts.serializers import UserSerializer
from typing import List, Tuple
from math import radians, sin, cos, sqrt, atan2
from queue import PriorityQueue
import heapq
import requests
from drf_yasg import openapi
from drf_yasg.utils import swagger_auto_schema
# from .serializer import CommunitySearchSerializer
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
    
def distance(user1: User, user2: User) -> float:
    R = 6371 # radius of Earth in km
    lat1, lon1, lat2, lon2 = map(radians,[user1.latitude,user1.longitude,user2.latitude,user2.longitude])
    dlat = lat2 - lat1
    dlon = lon2 - lon1
    a = sin(dlat /2)**2 + cos(lat1) * cos(lat2) * sin(dlon /2)**2
    c = 2 * atan2(sqrt(a), sqrt(1-a))
    return R * c

def find_nearest_users_astar(current_user: User, n: int, r: float) -> List[Tuple[User, float]]:
    visited = set()
    queue = PriorityQueue()
    queue.put((0, current_user))
    nearest_users = []
    user_warrior_relations = UserWarrior.objects.filter(user=current_user)
    acquaintances = [user_warrior_relation.warrior for user_warrior_relation in user_warrior_relations]
    url = 'https://rakshika.onrender.com/network/notification/'

    while not queue.empty():
        _, user = queue.get()
        if user not in visited:
            visited.add(user)
            dist = distance(current_user, user)
            if dist <= r:
                if len(nearest_users) < n:
                    # SendNotificationView.post(user)
                    params = {
                        id: user.id,
                    }
                    data = {
                        'latitude': current_user.latitude,
                        'longitude': current_user.longitude
                    }
                    response = requests.post(url, params=params, data=data)
                    # Check if the request was successful
                    if response.status_code != 200:
                        return [-1]
                    heapq.heappush(nearest_users, (-dist, user))
                else:
                    heapq.heappushpop(nearest_users, (-dist, user))
            for acquaintance in acquaintances:
                if acquaintance not in visited:
                    h = sqrt((acquaintance.latitude - current_user.latitude) ** 2 + (acquaintance.longitude - current_user.longitude) ** 2)
                    queue.put((h, acquaintance))

    return [(user, -dist) for dist, user in nearest_users]

class UserCommunityTrustSearch(generics.GenericAPIView):
    permission_classes = [IsAuthenticated,]
    # serializer_class = CommunitySearchSerializer

    latitude_param = openapi.Parameter('latitude', openapi.IN_QUERY, description="Latitude", type=openapi.TYPE_STRING)
    longitude_param = openapi.Parameter('longitude', openapi.IN_QUERY, description="Longitude", type=openapi.TYPE_STRING)

    @swagger_auto_schema(
        operation_description="Run Astar algorithm for community search",
        manual_parameters=[latitude_param, longitude_param]
    )
    def get(self, request):
        try:
            user=User.objects.get(aadhar_number = request.user.aadhar_number)
        except User.DoesNotExist:
            content = {'detail': 'No such user exists'}
            return JsonResponse(content, status = status.HTTP_404_NOT_FOUND)
        serializer = UserSerializer(instance = user, data=request.data, partial = True)
        if serializer.is_valid():
            serializer.save()
        nearest_users = find_nearest_users_astar(user, 20, 5)
        if nearest_users[0] == -1:
            content = {'detail': 'Error in sending notification'}
            return JsonResponse(content, status = status.HTTP_404_NOT_FOUND)
        nearest_users = [user for user, _ in nearest_users]
        nearest_users_details = UserSerializer(nearest_users, many=True, context={'request': request})
        return JsonResponse(nearest_users_details.data, safe = False, status = status.HTTP_200_OK)