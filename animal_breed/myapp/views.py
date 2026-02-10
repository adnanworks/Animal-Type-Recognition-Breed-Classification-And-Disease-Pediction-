from datetime import date

from django.contrib import messages
from django.contrib.auth import authenticate, login
from django.contrib.auth.hashers import make_password
from django.contrib.auth.models import Group
from django.core.files.storage import FileSystemStorage
from django.db.models import Q
from django.http import JsonResponse
from django.shortcuts import render, redirect


# Create your views here.
from myapp.models import *


def index(request):
    return render(request,'index.html')

def login_get(request):
    return render(request,'login.html')


def login_post(request):
    if request.method == "POST":
        username = request.POST["username"]
        password = request.POST["password"]

        user = authenticate(request, username=username, password=password)
        if user is not None:
            print("hhh")
            if user.groups.filter(name="admin").exists():
                print("jajaja")
                login(request,user)
                return redirect('/myapp/admin_home/')
            elif user.groups.filter(name="agent").exists():
                s = Agent.objects.get(LOGIN_id=user.id)
                print(user.id,'user')
                if s.status == 'Active':
                    login(request, user)
                    return redirect('/myapp/agent_home/')
                elif s.status == 'Blocked':
                    print("not act")
                    messages.error(request, "Id is not active, Contact Admin")
                    return redirect('/myapp/login_get/')


        else:
            messages.error(request, "Invalid username or password")
            print("helloooo")
            return redirect('/myapp/login_get/')



def admin_home(request):
    return render(request,'admin/home.html')

def add_wild_places(request):
    return render(request,'admin/add_wildlife_place.html')

def add_wildlife_place_post(request):
    place_name = request.POST['place_name']
    description = request.POST['description']
    location = request.POST['location']
    type = request.POST['type']
    latitute = request.POST['latitute']
    longitude = request.POST['longitude']

    w = WildlifePlace()
    w.place_name = place_name
    w.description = description
    w.location = location
    w.type = type
    w.latitute = latitute
    w.longitude = longitude
    w.save()

    messages.success(request, 'Wildlife Place Added Successfully')
    return redirect('/myapp/view_wild_places/')

def view_wild_places(request):
    p=WildlifePlace.objects.all()
    return render(request,'admin/view_wildlife_place.html',{'data':p})

def edit_wildlife_place_get(request, id):
    i = WildlifePlace.objects.get(id=id)
    return render(request, 'admin/edit_wildlife_place.html', {'i': i})


def edit_wildlife_place_post(request):
    id = request.POST['id']
    i = WildlifePlace.objects.get(id=id)

    place_name = request.POST['place_name']
    description = request.POST['description']
    location = request.POST['location']
    type = request.POST['type']
    latitute = request.POST['latitute']
    longitude = request.POST['longitude']

    i.place_name = place_name
    i.description = description
    i.location = location
    i.type = type
    i.latitute = latitute
    i.longitude = longitude
    i.save()
    messages.success(request, 'Wildlife Place details edited')
    return redirect('/myapp/view_wild_places/')


def admin_verify_agent_get(request):
    p=Agent.objects.all()
    return render(request,'admin/verify_agent.html',{'data':p})

def admin_verify_agent_post(request):
    if request.method=='POST':
        if 'unblock' in request.POST:
            id=request.POST.get('unblock')
            i=Agent.objects.get(id=id)
            i.status='Active'
            i.save()
            messages.success(request, 'Accepted')
            return redirect('/myapp/admin_verify_agent_get/')
        elif 'block' in request.POST:
            id = request.POST.get('block')
            i = Agent.objects.get(id=id)
            i.status = 'Blocked'
            i.save()
            messages.success(request, 'Blocked')
            return redirect('/myapp/admin_verify_agent_get/')
def admin_view_users_get(request):
    p=UserProfile.objects.all()
    return render(request,'admin/view_users.html',{'data':p})

def admin_view_complaints(request):
    p=Complaint.objects.all()
    return render(request,'admin/view_complaint.html',{'data':p})

def admin_view_feedback(request):
    p=Feedback.objects.all()
    return render(request,'admin/view_feedback.html',{'data':p})

def admin_view_Place_rating(request):
    p=Rating.objects.all()
    return render(request,'admin/view_feedback.html',{'data':p})

def changepwd_admin_get(request):
    return render(request,'admin/chnage_pwd.html')

def changepwd_admin_post(request):
    if request.method== 'POST':
        cpass=request.POST['cpass']
        npass = request.POST['npass']
        cmpass=request.POST['cmpass']

        user=request.user

        if not user.check_password(cpass):
            messages.error(request, 'Current password incorrect')
            return redirect('/myapp/changepwd_admin_get/')
        if npass != cmpass:
            messages.error(request, 'New password and confirm password do not match')
            return redirect('/myapp/changepwd_admin_get/')

        user.set_password(npass)
        user.save()
        messages.error(request, ' password changed')
        return redirect('/myapp/login_get/')



# ========================AGENT====================================
# =================================================================
# =================================================================


def agent_register_get(request):
    return render(request,'agent/register.html')

def agent_register_post(request):
    if request.method == 'POST':
        name = request.POST['name']
        email = request.POST['email']
        phone = request.POST['phone']
        place = request.POST['place']
        photo = request.FILES['photo']
        pwd = request.POST['pwd']
        cpwd = request.POST['cpwd']

        if pwd != cpwd:
            messages.error(request, "Passwords do not match.")
            return redirect('/myapp/agent_register_get/')

        var = User.objects.filter(Q(username=email) | Q(email=email))
        if var.exists():
            messages.error(request, 'User Already Exists')
            return redirect('/myapp/agent_register_get/')

        fs = FileSystemStorage()
        path = fs.save(photo.name, photo)

        ab = User.objects.create(
            username=email,
            password=make_password(pwd),
            email=email,
            first_name=name
        )

        ab.groups.add(Group.objects.get(name='agent'))

        ag = Agent()
        ag.LOGIN = ab
        ag.name = name
        ag.email = email
        ag.place = place
        ag.phone = phone
        ag.photo = path
        ag.status = 'Blocked'
        ag.save()

        messages.success(request, 'Registered')
        return redirect('/myapp/login_get/')

def agent_home(request):
    return render(request,'agent/home.html')


def agent_viewprofile(request):
    res = Agent.objects.get(LOGIN=request.user)
    return render(request, "agent/view_profile.html", {"i": res})


def agent_edit_profile_get(request, id):
    p = Agent.objects.get(id=id)
    return render(request, 'agent/edit_profile.html', {"i": p})


def agent_edit_profile_post(request):
    id = request.POST['id']
    name = request.POST['name']
    email = request.POST['email']
    phone = request.POST['phone']
    place = request.POST['place']

    data = Agent.objects.get(id=id)
    user = data.LOGIN
    user.username = email
    user.email = email
    user.save()

    if 'photo' in request.FILES:
        photo = request.FILES['photo']
        fs = FileSystemStorage()
        path = fs.save(photo.name, photo)
        data.photo = path

    data.name = name
    data.phone = phone
    data.place = place
    data.email = email
    data.save()
    messages.success(request, 'Profile edited')
    return redirect('/myapp/agent_viewprofile/')

def changepwd_agent_get(request):
    return render(request,'agent/change_pwd.html')

def changepwd_agent_post(request):
    if request.method== 'POST':
        cpass=request.POST['cpass']
        npass = request.POST['npass']
        cmpass=request.POST['cmpass']

        user=request.user

        if not user.check_password(cpass):
            messages.error(request, 'Current password incorrect')
            return redirect('/myapp/changepwd_agent_get/')
        if npass != cmpass:
            messages.error(request, 'New password and confirm password do not match')
            return redirect('/myapp/changepwd_agent_get/')

        user.set_password(npass)
        user.save()
        messages.error(request, ' password changed')
        return redirect('/myapp/login_get/')


def agent_view_places(request):
    p=WildlifePlace.objects.all()
    return render(request,'agent/view_places.html',{'data':p})

def agent_add_package_get(request, id):
    p = WildlifePlace.objects.get(id=id)
    return render(request, 'agent/add_package.html', {"i": p})

def agent_add_package_post(request):
        title = request.POST['title']
        description = request.POST['Description']
        price = request.POST['price']
        days = request.POST['days']
        id = request.POST['id']

        agent = Agent.objects.get(LOGIN=request.user)

        ag = Package()
        ag.AGENT_id = agent.id
        ag.PLACE_id = id
        ag.title = title
        ag.description = description
        ag.price = price
        ag.days = days
        ag.save()
        return redirect('/myapp/agent_view_places/')

def agent_view_package(request):
    agent = Agent.objects.get(LOGIN_id=request.user.id)
    packages = Package.objects.filter(AGENT=agent)
    return render(request, 'agent/view_pacakge.html', {'data': packages})

def agent_edit_package(request, id):
    p = Package.objects.get(id=id)
    return render(request, 'agent/edit_package.html', {"data": p})

def edit_package_post(request):
    id = request.POST['id']
    i = Package.objects.get(id=id)

    title = request.POST['title']
    description = request.POST['description']
    days = request.POST['days']
    price = request.POST['price']

    i.title = title
    i.description = description
    i.days = days
    i.price = price
    i.save()

    messages.success(request, 'Package details edited successfully')
    return redirect('/myapp/agent_view_package/#ab')


def agent_delete_package(request,id):
    i = Package.objects.get(id=id)
    i.delete()
    messages.success(request, 'Details deleted')
    return redirect('/myapp/agent_view_package/')

def agent_add_guides_get(request):
    return render(request, 'agent/add_guides.html')



def add_guide_post(request):
        name = request.POST['name']
        email = request.POST['email']
        phone = request.POST['phone']
        place = request.POST['place']
        photo = request.FILES['photo']
        a=Agent.objects.get(LOGIN_id=request.user.id)

        user = User.objects.create_user(
            username=email,
            password=phone
        )
        user.groups.add(Group.objects.get(name='guide'))

        guide = Guide()
        guide.LOGIN = user
        guide.AGENT_id = a.id
        guide.name = name
        guide.email = email
        guide.phone = phone
        guide.place = place
        guide.photo = photo
        guide.save()

        messages.success(request, 'Guide added successfully')
        return redirect('/myapp/agent_add_guides_get/')

def agent_view_guides(request):
    agent = Agent.objects.get(LOGIN_id=request.user.id)
    a = Guide.objects.filter(AGENT=agent)
    return render(request, 'agent/view_guides.html', {'data': a})

def agent_edit_guide(request, id):
    g = Guide.objects.get(id=id)
    return render(request, 'agent/edit_guide.html', {'data': g})


def agent_edit_guide_post(request):
    id = request.POST['id']
    name = request.POST['name']
    email = request.POST['email']
    phone = request.POST['phone']
    place = request.POST['place']
    g = Guide.objects.get(id=id)

    if 'photo' in request.FILES:
        photo = request.FILES['photo']
        fs = FileSystemStorage()
        path = fs.save(photo.name, photo)
        g.photo = path
        g.save()
    g.name = name
    g.email = email
    g.phone = phone
    g.place = place
    g.save()

    messages.success(request, 'Guide details updated successfully')
    return redirect('/myapp/agent_view_guides/')

def agent_delete_guide(request,id):
    i = Guide.objects.get(id=id)
    i.delete()
    user = i.LOGIN
    user.delete()
    messages.success(request, 'Guide deleted')
    return redirect('/myapp/agent_view_guides/')

def assign_guide_to_package(request, id):
    g = Guide.objects.all()
    p = Package.objects.get(id=id)
    return render(request, 'agent/assign_guide_to_pck.html', {"data": p,'guides':g})

def agent_assign_guide_post(request):
    pid = request.POST['pid']
    guide_id = request.POST['guide_id']
    g = Guide.objects.get(id=guide_id)
    p = Package.objects.get(id=pid)

    a = Assign_package()
    a.GUIDE_id = g.id
    a.PACKAGE_id = p.id
    a.date=date.today()
    a.save()

    messages.success(request, 'Guide assigned to package successfully')
    return redirect('/myapp/agentview_assign_package/#ab')

def agentview_assign_package(request):
    a = Assign_package.objects.all()
    return render(request, 'agent/view_assign_packages.html',{'data': a,})

def delete_assign_package(request,id):
    d=Assign_package.objects.get(id=id)
    d.delete()
    messages.success(request,'Deleted')
    return redirect('/myapp/agentview_assign_package/#ab')


# ========================USER============================
# ========================================================
# ========================================================


def flutter_login(request):
    if request.method == "POST":
        uname = request.POST.get('Username')
        pwd = request.POST.get('Password')

        user = authenticate(request, username=uname, password=pwd)

        if user is not None:
            login(request, user)
            lid = user.id
            if user.groups.filter(name="guide").exists():
                s= Guide.objects.get(LOGIN_id=lid)
                print(lid,'lid')
                print(s.id,'sid')
                return JsonResponse({
                    'status': 'ok',
                    'type': 'guide',
                    'lid': str(lid),
                    'sid': str(s.id),
                    'message': 'Login successful'
                })
            elif user.groups.filter(name="user").exists():
                s= UserProfile.objects.get(LOGIN_id=lid)
                print(lid,'lid')
                print(s.id,'sid')
                return JsonResponse({
                    'status': 'ok',
                    'type': 'user',
                    'lid': str(lid),
                    'sid': str(s.id),
                    'message': 'Login successful'
                })
            else:
                return JsonResponse({
                    'status': 'failed',
                    'message': ' record not found'
                })

        else:
            return JsonResponse({
                'status': 'failed',
                'message': 'Invalid username or password'
            })
    else:
        return JsonResponse({
            'status': 'failed',
            'message': 'Only POST requests are allowed'
        })



def guide_viewprofile(request):
    lid = request.POST['lid']
    print(lid,'login_id================')
    profile = Guide.objects.get(LOGIN_id=lid)
    print(profile,'-----------------')
    return JsonResponse({'status': 'ok',
                         'name': str(profile.name),
                         'email': str(profile.email),
                         'place': str(profile.place),
                         'agent': str(profile.AGENT.name),
                         'photo': str(profile.photo),
                         'phone':str(profile.phone),})


def guide_view_assipackages(request):
    lid = request.POST['lid']
    print(lid,'id----------------')
    g=Guide.objects.get(LOGIN_id=lid)

    n = Assign_package.objects.filter(GUIDE_id=g.id)
    data = []
    for i in n:
        data.append({
            'id':i.id,
            'package': str(i.PACKAGE.title),
            'description': str(i.PACKAGE.description),
            'price': str(i.PACKAGE.price),
            'days': str(i.PACKAGE.days),
            'date':str(i.date),
            'STATUS':str(i.status)
        })
    print(data)
    return JsonResponse({'status': 'ok','data': data})


def guide_accept_package(request):
    aid = request.POST['assigned_id']
    Assign_package.objects.filter(id=aid).update(status='accepted')
    return JsonResponse({'status': 'ok','message':'accepted'})

def guide_reject_package(request):
    aid = request.POST['assigned_id']
    Assign_package.objects.filter(id=aid).update(status='rejected')
    return JsonResponse({'status': 'ok','message':'rejected'})



# =======================USER================================
# ===========================================================
# ===========================================================



def user_register(request):
    name = request.POST['name']
    email = request.POST['email']
    place = request.POST['place']
    dob = request.POST['dob']
    phone = request.POST['phone']
    photo = request.FILES['photo']
    username = request.POST['username']
    password = request.POST['password']
    cpassword = request.POST['cpassword']

    fs = FileSystemStorage()
    path = fs.save(photo.name, photo)

    if password==cpassword:
        if User.objects.filter(username=username).exists():
            return JsonResponse({'status': 'failed',
                'message': 'User ID already exists.'})
        user = User.objects.create_user(username=username, password=password, email=email,first_name=name)
        user.groups.add(Group.objects.get(name='user'))
        user.save()
        res=UserProfile(name=name,email=email,place=place,dob=dob,
                              phone=phone,photo=path,
                            status='Active', LOGIN_id=user.id,)
        res.save()


        return JsonResponse({'status': 'ok',
            'message': 'Account registered successfully.'})
    else:
        return JsonResponse({'status': 'failed',
            'message': 'Passwords do not match.'})



def user_viewprofile(request):
    lid = request.POST['lid']
    print(lid,'login_id================')
    profile = UserProfile.objects.get(LOGIN_id=lid)
    print(profile,'-----------------')
    return JsonResponse({'status': 'ok',
                         'name': str(profile.name),
                         'email': str(profile.email),
                         'place': str(profile.place),
                         'dob': str(profile.dob),
                         'photo': str(profile.photo),
                         'phone':str(profile.phone),})


def user_profileviewforedit(request):
    lid = request.POST['lid']
    print(lid,'-------------------id')
    i = UserProfile.objects.get(LOGIN_id=lid)
    print(i.photo.url, 'photo')
    return JsonResponse({
                          'status': 'ok',
                         'name': str(i.name),
                         'dob': str(i.dob),
                         'place': str(i.place),
                         'email':str(i.email),
                         'phone':str(i.phone),
                         'photo':str(i.photo.url),
                         })



def user_editprofile(request):
    lid = request.POST['lid']
    name = request.POST['name']
    dob = request.POST['dob']
    place = request.POST['place']
    phone = request.POST['phone']
    email = request.POST['email']

    print(name,'=================name')

    i = UserProfile.objects.get(LOGIN_id=lid)
    if 'photo' in request.FILES:
        photo = request.FILES['photo']
        fs = FileSystemStorage()
        paths = fs.save(photo.name, photo)
        i.photo = paths
        i.save()

    user=i.LOGIN
    user.email=email
    user.save()


    i.name=name
    i.dob=dob
    i.place=place
    i.phone = phone
    i.email=email
    i.save()
    return JsonResponse({'status': 'ok',
                         'message': 'Profile edited successfully.'})


def user_viewplaces(request):
    # lid = request.POST['lid']
    # print(lid,'id----------------')

    n = WildlifePlace.objects.all()
    data = []
    for i in n:
        data.append({
            'id':i.id,
            'placename': str(i.place_name),
            'description': str(i.description),
            'location': str(i.location),
            'type': str(i.type),
            'latitute':str(i.latitute),
            'longitude':str(i.longitude)
        })
    print(data)
    return JsonResponse({'status': 'ok','data': data})