from django.urls import path
from . import views

urlpatterns = [
    path('', views.SendRequestView.as_view(), name = 'SendRequest'),
]