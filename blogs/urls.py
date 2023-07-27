from django.urls import path
from . import views

urlpatterns = [
    path('', views.BlogsView.as_view(), name = "Blogs"),
]