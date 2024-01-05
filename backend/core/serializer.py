from rest_framework import serializers
from .models import User, Room, Booking
from django.contrib.auth import authenticate, get_user_model



class UserSerializer(serializers.ModelSerializer):

    class Meta:
        model = get_user_model()
        fields = ('id', 'name','email')

    def create(self, validated_data):
        return get_user_model().objects.create_user(**validated_data)



class BookingSerializer(serializers.ModelSerializer):
    class Meta:
        model = Booking
        fields = '__all__'


class RoomSerializer(serializers.ModelSerializer):
    class Meta:
        model = Room
        fields = '__all__'



class AuthTokenSerializer(serializers.Serializer):
    email = serializers.EmailField()
    password = serializers.CharField(
        style={'input_type': 'password'},
        trim_whitespace=False
    )

    def validate(self, attrs):
        email = attrs.get('email')
        password = attrs.get('password')
        user = authenticate(
            request=self.context.get('request'),
            username=email,
            password=password,
        )
        if not user:
            msg = 'Unable to log in with provided credentials'
            raise serializers.ValidationError(msg, code='authorization')
        attrs['user'] = user
        return attrs


