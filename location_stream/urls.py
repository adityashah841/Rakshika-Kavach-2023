from django.urls import path
from . import views

urlpatterns = [
    path('update_location/', views.LocationStreamView.as_view(), name="LocationStream"),
]