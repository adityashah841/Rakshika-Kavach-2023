from django.urls import path
from . import views

urlpatterns = [
    path('<str:pk>/', views.BlogsView.as_view(), name = "Blogs"),
]