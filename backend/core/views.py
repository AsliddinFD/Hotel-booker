from rest_framework import generics, permissions, views, response, status, serializers, authentication
from .models import User, Booking, Room
from rest_framework.authtoken.views import ObtainAuthToken
from rest_framework.settings import api_settings
from .serializer import UserSerializer, BookingSerializer, RoomSerializer, AuthTokenSerializer
from datetime import datetime
from django.http import JsonResponse


class CreateUser(generics.CreateAPIView):
    serializer_class = UserSerializer
    queryset = User.objects.all()


class Login(ObtainAuthToken):
    serializer_class = AuthTokenSerializer
    renderer_classes = api_settings.DEFAULT_RENDERER_CLASSES

class UserInfoAPIView(generics.RetrieveAPIView):
    authentication_classes = [authentication.TokenAuthentication]
    permission_classes = [permissions.IsAuthenticated]

    def get(self, request, *args, **kwargs):
        # Retrieve the user associated with the provided token
        user = request.user

        # Serialize the user information
        serializer = UserSerializer(user)

        return response.Response(serializer.data, status=status.HTTP_200_OK)

class DeleteAccount(views.APIView):
    permission_classes = [permissions.IsAuthenticated]

    def delete(self, request):
        user = request.user
        user.delete()
        return response.Response({"message": "Account deleted successfully"}, status=status.HTTP_204_NO_CONTENT)


class CreateBooking(generics.CreateAPIView):
    serializer_class = BookingSerializer
    permission_classes = [permissions.IsAuthenticated]
    
    def perform_create(self, serializer):
        
        room_id = self.request.data.get('room', None)
        starting_date = self.request.data.get('starting_date', None)
        ending_date = self.request.data.get('ending_date', None)
        
        try:
            room = Room.objects.get(pk=room_id)
        except Room.DoesNotExist:
            raise serializers.ValidationError("Room does not exist.")
        
        
        room.is_booked = True
        room.booking_start_date = starting_date
        room.booking_end_date = ending_date
        room.save()

        
        serializer.save(customer=self.request.user, starting_date=starting_date, ending_date=ending_date)

    

class ListBookings(generics.ListAPIView):
    queryset = Booking.objects.all()
    serializer_class = BookingSerializer
    permission_classes = [permissions.IsAuthenticated]
    

class CancelBooking(generics.DestroyAPIView):
    queryset = Booking.objects.all()
    serializer_class = BookingSerializer
    permission_classes = [permissions.IsAuthenticated]

    
    def delete(self, request, *args, **kwargs):
        return super().delete(request, *args, **kwargs)
    
class UpdateBooking(generics.UpdateAPIView):
    queryset = Booking.objects.all()
    serializer_class = BookingSerializer
    permission_classes = [permissions.IsAuthenticated]


class ListRooms(generics.ListAPIView):
    queryset = Room.objects.all()
    serializer_class = RoomSerializer