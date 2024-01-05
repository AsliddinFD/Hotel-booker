from django.urls import path
from . import views


urlpatterns = [
    path('user/', views.UserInfoAPIView.as_view()),
    path('user/create/', views.CreateUser.as_view()),
    path('user/login/', views.Login.as_view()),
    path('bookings/', views.ListBookings.as_view()),
    path('booking/create/', views.CreateBooking.as_view()),
    path('booking/<int:pk>/cancel/', views.CancelBooking.as_view()),
    path('booking/update/', views.UpdateBooking.as_view()),
    path('rooms/', views.ListRooms.as_view())
]
