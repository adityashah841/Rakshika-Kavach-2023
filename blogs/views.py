from django.shortcuts import render
from django.http.response import HttpResponse, JsonResponse
import jwt
from rest_framework.views import APIView
from rest_framework import (mixins, generics, status, permissions)
from rest_framework.response import Response
from .models import *
from .serializers import *
from drf_yasg import openapi
from drf_yasg.utils import swagger_auto_schema
from rest_framework.permissions import IsAuthenticated
import pytz

# Create your views here.
class BlogsView(generics.GenericAPIView):
    permission_classes = (IsAuthenticated,)
    serializer_class = BlogSerializer
    @swagger_auto_schema(
        operation_description="Get all blogs",
    #     responses={200: openapi.Response('OK', openapi.Schema(
    #         type=openapi.TYPE_OBJECT,
    #         properties={
    #             'title': openapi.Schema(type=openapi.TYPE_STRING),
    #             'content': openapi.Schema(type=openapi.TYPE_STRING),
    #             'author': openapi.Schema(type=openapi.TYPE_STRING),
    #             'created_at': openapi.Schema(type=openapi.TYPE_STRING),
    #             'updated_at': openapi.Schema(type=openapi.TYPE_STRING),
    #         }
    #     ))},
    )
    def get(self, request):
        blogs = Blog.objects.all()
        serializer = self.serializer_class(blogs, many=True)
        return Response(serializer.data, status=status.HTTP_200_OK)

    @swagger_auto_schema(
        operation_description="Create a blog",
    #     request_body=openapi.Schema(
    #         type=openapi.TYPE_OBJECT,
    #         properties={
    #             'title': openapi.Schema(type=openapi.TYPE_STRING),
    #             'content': openapi.Schema(type=openapi.TYPE_STRING),
    #             'author': openapi.Schema(type=openapi.TYPE_STRING),
    #         }
    #     ),
    #     responses={200: openapi.Response('OK', openapi.Schema(
    #         type=openapi.TYPE_OBJECT,
    #         properties={
    #             'title': openapi.Schema(type=openapi.TYPE_STRING),
    #             'content': openapi.Schema(type=openapi.TYPE_STRING),
    #             'author': openapi.Schema(type=openapi.TYPE_STRING),
    #             'created_at': openapi.Schema(type=openapi.TYPE_STRING),
    #             'updated_at': openapi.Schema(type=openapi.TYPE_STRING),
    #         }
    #     ))},
    )
    def post(self, request):
        serializer = self.serializer_class(data=request.data)
        # print(serializer.initial_data)
        if serializer.is_valid():
            Blog.objects.get_or_create(
                title = serializer.data['title'],
                content = serializer.data['content'],
                author = serializer.data['author'],
            )
            # print(serializer.data)
            content = serializer.data
            content['created_at'] = Blog.objects.get(title = serializer.data['title'], author = serializer.data['author']).created_at.astimezone(pytz.timezone(settings.TIME_ZONE))
            content['updated_at'] = Blog.objects.get(title = serializer.data['title'], author = serializer.data['author']).updated_at.astimezone(pytz.timezone(settings.TIME_ZONE))
            return Response(content, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
    
    # Add a method to update an existing blog, where blog can be identified by its title and author, and also add the updated_at date at this time (ignore the last part if it is already being handled in models)

    @swagger_auto_schema(
        operation_description="Update a blog",
    #     request_body=openapi.Schema(
    #         type=openapi.TYPE_OBJECT,
    #         properties={
    #             'title': openapi.Schema(type=openapi.TYPE_STRING),
    #             'content': openapi.Schema(type=openapi.TYPE_STRING),
    #             'author': openapi.Schema(type=openapi.TYPE_STRING),
    #         }
    #     ),
    #     responses={200: openapi.Response('OK', openapi.Schema(
    #         type=openapi.TYPE_OBJECT,
    #         properties={
    #             'title': openapi.Schema(type=openapi.TYPE_STRING),
    #             'content': openapi.Schema(type=openapi.TYPE_STRING),
    #             'author': openapi.Schema(type=openapi.TYPE_STRING),
    #             'created_at': openapi.Schema(type=openapi.TYPE_STRING),
    #             'updated_at': openapi.Schema(type=openapi.TYPE_STRING),
    #         }
    #     ))},
    )
    def put(self, request):
        serializer = self.serializer_class(data=request.data)
        if serializer.is_valid():
            try: 
                blog = Blog.objects.get(title = serializer.data['title'], author = serializer.data['author'])
            except Blog.DoesNotExist:
                content = {'detail': 'Blog does not exist'}
                return JsonResponse(content, status = status.HTTP_404_NOT_FOUND) 
            blog.content = serializer.data['content']
            blog.save()
            content = serializer.data
            content['created_at'] = Blog.objects.get(title = serializer.data['title'], author = serializer.data['author']).created_at.astimezone(pytz.timezone(settings.TIME_ZONE))
            content['updated_at'] = Blog.objects.get(title = serializer.data['title'], author = serializer.data['author']).updated_at.astimezone(pytz.timezone(settings.TIME_ZONE))
            return Response(content, status=status.HTTP_200_OK)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
    
    # Add a method to delete an existing blog, where blog can be identified by its title and author

    # generate swagger auto schema for delete API for parameter title (which is separate from the request_body)


    @swagger_auto_schema(
        operation_description="Delete a blog",
        request_body=openapi.Schema(
            
            type=openapi.TYPE_OBJECT,
            properties={
                'title': openapi.Schema(type=openapi.TYPE_STRING),
            },
            required=['title']
        ),
    #     responses={200: openapi.Response('OK', openapi.Schema(
    #         type=openapi.TYPE_OBJECT,
    #         properties={
    #             'title': openapi.Schema(type=openapi.TYPE_STRING),
    #             'content': openapi.Schema(type=openapi.TYPE_STRING),
    #             'author': openapi.Schema(type=openapi.TYPE_STRING),
    #             'created_at': openapi.Schema(type=openapi.TYPE_STRING),
    #             'updated_at': openapi.Schema(type=openapi.TYPE_STRING),
    #         }
    #     ))},
    )

    def delete(self, request):
        serializer = self.serializer_class(data=request.data)
        if serializer.is_valid():
            try: 
                blog = Blog.objects.get(title = serializer.data['title'])   
            except Blog.DoesNotExist:
                content = {'detail': 'Blog does not exist'}
                return JsonResponse(content, status = status.HTTP_404_NOT_FOUND) 
            blog.delete()
            return Response({'title': request.data['title'], 'status': 'deleted'}, status=status.HTTP_200_OK)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)