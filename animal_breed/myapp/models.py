from django.db import models
from django.contrib.auth.models import User

# Create your models here.


class Agent(models.Model):
    LOGIN = models.OneToOneField(User, on_delete=models.CASCADE)
    name = models.CharField(max_length=100)
    email = models.CharField(max_length=100)
    place = models.CharField(max_length=100)
    phone = models.CharField(max_length=20)
    photo = models.FileField()
    status = models.CharField(max_length=50)



class Guide(models.Model):
    LOGIN = models.OneToOneField(User, on_delete=models.CASCADE)
    AGENT = models.ForeignKey(Agent, on_delete=models.CASCADE)
    name = models.CharField(max_length=100)
    email = models.CharField(max_length=100)
    phone = models.CharField(max_length=20)
    place = models.CharField(max_length=100)
    photo = models.FileField()
    # status = models.CharField(max_length=50)


class UserProfile(models.Model):
    LOGIN = models.OneToOneField(User, on_delete=models.CASCADE)
    name = models.CharField(max_length=100)
    email = models.CharField(max_length=100)
    place = models.CharField(max_length=100)
    dob = models.CharField(max_length=20)
    phone = models.CharField(max_length=20)
    status = models.CharField(max_length=20)
    photo = models.FileField()



class WildlifePlace(models.Model):
    place_name = models.CharField(max_length=100)
    description = models.CharField(max_length=100)
    location = models.CharField(max_length=200)
    type = models.CharField(max_length=200)
    latitute = models.CharField(max_length=200)
    longitude = models.CharField(max_length=200)



class Package(models.Model):
    AGENT = models.ForeignKey(Agent, on_delete=models.CASCADE)
    PLACE = models.ForeignKey(WildlifePlace, on_delete=models.CASCADE)
    title = models.CharField(max_length=100)
    description = models.TextField()
    price = models.CharField(max_length=50)
    days = models.CharField(max_length=20)

class Assign_package(models.Model):
    GUIDE = models.ForeignKey(Guide, on_delete=models.CASCADE)
    PACKAGE = models.ForeignKey(Package, on_delete=models.CASCADE)
    status=models.CharField(max_length=20,default='assigned')
    date = models.CharField(max_length=20)


class Booking(models.Model):
    USER = models.ForeignKey(UserProfile, on_delete=models.CASCADE)
    PACKAGE = models.ForeignKey(Package, on_delete=models.CASCADE)
    booked_date = models.CharField(max_length=50)
    from_date = models.CharField(max_length=50)

    status = models.CharField(max_length=50)



class Complaint(models.Model):
    USER = models.ForeignKey(UserProfile, on_delete=models.CASCADE)
    complaint = models.CharField(max_length=100)
    reply = models.CharField(max_length=100)
    date = models.DateField()



class Feedback(models.Model):
    USER = models.ForeignKey(UserProfile, on_delete=models.CASCADE)
    feedback = models.TextField()
    date = models.DateField()



class Rating(models.Model):
    USER = models.ForeignKey(UserProfile, on_delete=models.CASCADE)
    PLACE = models.ForeignKey(WildlifePlace, on_delete=models.CASCADE)
    rating = models.IntegerField()
    review = models.TextField()