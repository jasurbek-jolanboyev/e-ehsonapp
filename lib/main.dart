import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math';
import 'dart:async';

void main() {
  runApp(EEhsonGlobalApp());
}

class EEhsonGlobalApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'E-Ehson Global v36',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Roboto',
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

// Splash Screen
class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller);

    _controller.forward();

    Timer(Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MainScreen()),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.blue.shade600, Colors.purple.shade600],
          ),
        ),
        child: Center(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(60),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 20,
                        offset: Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.favorite,
                    size: 60,
                    color: Colors.red,
                  ),
                ),
                SizedBox(height: 30),
                Text(
                  'E-Ehson Global',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  'v36 Professional',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white70,
                  ),
                ),
                SizedBox(height: 50),
                CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Data Models
class User {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final String userType;
  final String status;
  final DateTime createdAt;
  final String? organizationName;

  User({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.userType,
    required this.status,
    required this.createdAt,
    this.organizationName,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
        'phone': phone,
        'userType': userType,
        'status': status,
        'createdAt': createdAt.toIso8601String(),
        'organizationName': organizationName,
      };

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json['id'],
        firstName: json['firstName'],
        lastName: json['lastName'],
        email: json['email'],
        phone: json['phone'],
        userType: json['userType'],
        status: json['status'],
        createdAt: DateTime.parse(json['createdAt']),
        organizationName: json['organizationName'],
      );
}

class Campaign {
  final String id;
  final String title;
  final String description;
  final double targetAmount;
  double currentAmount;
  String status;
  final String category;
  final String image;
  int donors;
  final DateTime createdAt;
  final DateTime endDate;
  final String createdBy;

  Campaign({
    required this.id,
    required this.title,
    required this.description,
    required this.targetAmount,
    this.currentAmount = 0,
    required this.status,
    required this.category,
    required this.image,
    this.donors = 0,
    required this.createdAt,
    required this.endDate,
    required this.createdBy,
  });

  double get progressPercentage =>
      (currentAmount / targetAmount * 100).clamp(0, 100);

  int get daysLeft {
    final now = DateTime.now();
    final difference = endDate.difference(now).inDays;
    return difference > 0 ? difference : 0;
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'targetAmount': targetAmount,
        'currentAmount': currentAmount,
        'status': status,
        'category': category,
        'image': image,
        'donors': donors,
        'createdAt': createdAt.toIso8601String(),
        'endDate': endDate.toIso8601String(),
        'createdBy': createdBy,
      };

  factory Campaign.fromJson(Map<String, dynamic> json) => Campaign(
        id: json['id'],
        title: json['title'],
        description: json['description'],
        targetAmount: json['targetAmount'].toDouble(),
        currentAmount: json['currentAmount'].toDouble(),
        status: json['status'],
        category: json['category'],
        image: json['image'],
        donors: json['donors'],
        createdAt: DateTime.parse(json['createdAt']),
        endDate: DateTime.parse(json['endDate']),
        createdBy: json['createdBy'],
      );
}

class Donation {
  final String id;
  final String campaignId;
  final String userId;
  final double amount;
  final String paymentMethod;
  final String? comment;
  final bool anonymous;
  final DateTime createdAt;

  Donation({
    required this.id,
    required this.campaignId,
    required this.userId,
    required this.amount,
    required this.paymentMethod,
    this.comment,
    this.anonymous = false,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'campaignId': campaignId,
        'userId': userId,
        'amount': amount,
        'paymentMethod': paymentMethod,
        'comment': comment,
        'anonymous': anonymous,
        'createdAt': createdAt.toIso8601String(),
      };

  factory Donation.fromJson(Map<String, dynamic> json) => Donation(
        id: json['id'],
        campaignId: json['campaignId'],
        userId: json['userId'],
        amount: json['amount'].toDouble(),
        paymentMethod: json['paymentMethod'],
        comment: json['comment'],
        anonymous: json['anonymous'],
        createdAt: DateTime.parse(json['createdAt']),
      );
}

// Data Manager
class DataManager {
  static final DataManager _instance = DataManager._internal();
  factory DataManager() => _instance;
  DataManager._internal();

  List<User> users = [];
  List<Campaign> campaigns = [];
  List<Donation> donations = [];
  User? currentUser;

  // Sample Data
  void initializeSampleData() {
    // Default admin user
    users.add(User(
      id: '1',
      firstName: 'Jasurbek',
      lastName: 'Jo\'lanboyev',
      email: 'jasurbekjolanboyev970@gmail.com',
      phone: '+998958883851',
      userType: 'admin',
      status: 'active',
      createdAt: DateTime.now(),
      organizationName: 'E-Ehson Global',
    ));

    // Sample campaigns
    campaigns.addAll([
      Campaign(
        id: '1',
        title: 'Anvar\'s Yurak Operatsiyasi',
        description:
            '7 yoshli Anvarning yurak operatsiyasi uchun yordam kerak. Bolaning hayoti xavf ostida va zudlik bilan operatsiya qilish zarur.',
        targetAmount: 50000000,
        currentAmount: 50000000,
        status: 'completed',
        category: 'tibbiyot',
        image: '🏥',
        donors: 234,
        createdAt: DateTime.now().subtract(Duration(days: 60)),
        endDate: DateTime.now().subtract(Duration(days: 30)),
        createdBy: '1',
      ),
      Campaign(
        id: '2',
        title: 'Qashqadaryo Maktabi',
        description:
            '200 nafar bola uchun yangi maktab qurilishi. Hozirgi maktab binosi eskirgan va ta\'lim sifatiga salbiy ta\'sir ko\'rsatmoqda.',
        targetAmount: 200000000,
        currentAmount: 150000000,
        status: 'active',
        category: 'ta\'lim',
        image: '🏫',
        donors: 567,
        createdAt: DateTime.now().subtract(Duration(days: 30)),
        endDate: DateTime.now().add(Duration(days: 45)),
        createdBy: '1',
      ),
      Campaign(
        id: '3',
        title: 'Katta Oila Uyi',
        description:
            '5 bolali oila uchun yangi uy qurilishi. Oila hozir ijaraga olingan kichik xonada yashaydi va o\'z uyiga muhtoj.',
        targetAmount: 80000000,
        currentAmount: 45000000,
        status: 'active',
        category: 'uy-joy',
        image: '🏠',
        donors: 189,
        createdAt: DateTime.now().subtract(Duration(days: 20)),
        endDate: DateTime.now().add(Duration(days: 30)),
        createdBy: '1',
      ),
      Campaign(
        id: '4',
        title: 'Bolalar Bog\'chasi Jihozlari',
        description:
            'Mahalliy bolalar bog\'chasi uchun o\'yin jihozlari va ta\'lim materiallari. 150 nafar bolaga xizmat ko\'rsatadi.',
        targetAmount: 25000000,
        currentAmount: 18500000,
        status: 'active',
        category: 'ta\'lim',
        image: '🎪',
        donors: 156,
        createdAt: DateTime.now().subtract(Duration(days: 15)),
        endDate: DateTime.now().add(Duration(days: 15)),
        createdBy: '1',
      ),
    ]);
  }

  // Storage methods
  Future<void> saveData() async {
    final prefs = await SharedPreferences.getInstance();

    final usersJson = users.map((u) => u.toJson()).toList();
    final campaignsJson = campaigns.map((c) => c.toJson()).toList();
    final donationsJson = donations.map((d) => d.toJson()).toList();

    await prefs.setString('users', jsonEncode(usersJson));
    await prefs.setString('campaigns', jsonEncode(campaignsJson));
    await prefs.setString('donations', jsonEncode(donationsJson));

    if (currentUser != null) {
      await prefs.setString('currentUser', jsonEncode(currentUser!.toJson()));
    }
  }

  Future<void> loadData() async {
    final prefs = await SharedPreferences.getInstance();

    try {
      final usersString = prefs.getString('users');
      if (usersString != null) {
        final usersJson = jsonDecode(usersString) as List;
        users = usersJson.map((u) => User.fromJson(u)).toList();
      }

      final campaignsString = prefs.getString('campaigns');
      if (campaignsString != null) {
        final campaignsJson = jsonDecode(campaignsString) as List;
        campaigns = campaignsJson.map((c) => Campaign.fromJson(c)).toList();
      }

      final donationsString = prefs.getString('donations');
      if (donationsString != null) {
        final donationsJson = jsonDecode(donationsString) as List;
        donations = donationsJson.map((d) => Donation.fromJson(d)).toList();
      }

      final currentUserString = prefs.getString('currentUser');
      if (currentUserString != null) {
        currentUser = User.fromJson(jsonDecode(currentUserString));
      }
    } catch (e) {
      print('Error loading data: $e');
      initializeSampleData();
    }

    if (users.isEmpty) {
      initializeSampleData();
    }
  }

  // User methods
  User? login(String identifier, String password) {
    final user = users.firstWhere(
      (u) =>
          (u.email == identifier || u.phone == identifier) &&
          u.status == 'active',
      orElse: () => throw Exception('Foydalanuvchi topilmadi'),
    );

    currentUser = user;
    saveData();
    return user;
  }

  User register(Map<String, dynamic> userData) {
    // Check if user already exists
    final existingUser = users.where(
        (u) => u.email == userData['email'] || u.phone == userData['phone']);

    if (existingUser.isNotEmpty) {
      throw Exception(
          'Bu email yoki telefon raqami allaqachon ro\'yxatdan o\'tgan');
    }

    final newUser = User(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      firstName: userData['firstName'],
      lastName: userData['lastName'],
      email: userData['email'],
      phone: userData['phone'],
      userType: userData['userType'] ?? 'user',
      status: 'active',
      createdAt: DateTime.now(),
      organizationName: userData['organizationName'],
    );

    users.add(newUser);
    saveData();
    return newUser;
  }

  void logout() {
    currentUser = null;
    saveData();
  }

  // Campaign methods
  Campaign createCampaign(Map<String, dynamic> campaignData) {
    if (currentUser == null) {
      throw Exception('Kampaniya yaratish uchun tizimga kiring');
    }

    final newCampaign = Campaign(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: campaignData['title'],
      description: campaignData['description'],
      targetAmount: campaignData['targetAmount'].toDouble(),
      status: 'active',
      category: campaignData['category'],
      image: _getCategoryIcon(campaignData['category']),
      createdAt: DateTime.now(),
      endDate: DateTime.parse(campaignData['endDate']),
      createdBy: currentUser!.id,
    );

    campaigns.add(newCampaign);
    saveData();
    return newCampaign;
  }

  String _getCategoryIcon(String category) {
    switch (category) {
      case 'tibbiyot':
        return '🏥';
      case 'ta\'lim':
        return '📚';
      case 'uy-joy':
        return '🏠';
      case 'ijtimoiy':
        return '🤝';
      case 'tabiat':
        return '🌱';
      case 'sport':
        return '⚽';
      default:
        return '❤️';
    }
  }

  // Donation methods
  Donation makeDonation(Map<String, dynamic> donationData) {
    if (currentUser == null) {
      throw Exception('Xayriya qilish uchun tizimga kiring');
    }

    final campaign = campaigns.firstWhere(
      (c) => c.id == donationData['campaignId'],
      orElse: () => throw Exception('Kampaniya topilmadi'),
    );

    final donation = Donation(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      campaignId: donationData['campaignId'],
      userId: currentUser!.id,
      amount: donationData['amount'].toDouble(),
      paymentMethod: donationData['paymentMethod'],
      comment: donationData['comment'],
      anonymous: donationData['anonymous'] ?? false,
      createdAt: DateTime.now(),
    );

    // Update campaign
    campaign.currentAmount += donation.amount;
    campaign.donors += 1;

    if (campaign.currentAmount >= campaign.targetAmount) {
      campaign.status = 'completed';
    }

    donations.add(donation);
    saveData();
    return donation;
  }

  // Statistics
  Map<String, dynamic> getStats() {
    final totalDonations =
        donations.fold<double>(0, (sum, d) => sum + d.amount);
    final activeCampaigns = campaigns.where((c) => c.status == 'active').length;
    final completedCampaigns =
        campaigns.where((c) => c.status == 'completed').length;

    final today = DateTime.now();
    final todayDonations = donations
        .where((d) =>
            d.createdAt.year == today.year &&
            d.createdAt.month == today.month &&
            d.createdAt.day == today.day)
        .fold<double>(0, (sum, d) => sum + d.amount);

    return {
      'totalUsers': users.length,
      'totalDonations': totalDonations,
      'activeCampaigns': activeCampaigns,
      'completedCampaigns': completedCampaigns,
      'todayDonations': todayDonations,
      'totalCampaigns': campaigns.length,
    };
  }
}

// Main Screen
class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  final DataManager _dataManager = DataManager();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    await _dataManager.loadData();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: [
          HomeScreen(),
          CampaignsScreen(),
          if (_dataManager.currentUser != null) ProfileScreen(),
          if (_dataManager.currentUser?.userType == 'admin') AdminScreen(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          if (index == 2 && _dataManager.currentUser == null) {
            _showLoginDialog();
            return;
          }
          if (index == 3 && _dataManager.currentUser?.userType != 'admin') {
            return;
          }
          setState(() {
            _currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Bosh sahifa',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.campaign),
            label: 'Kampaniyalar',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: _dataManager.currentUser != null ? 'Profil' : 'Kirish',
          ),
          if (_dataManager.currentUser?.userType == 'admin')
            BottomNavigationBarItem(
              icon: Icon(Icons.admin_panel_settings),
              label: 'Admin',
            ),
        ],
      ),
    );
  }

  void _showLoginDialog() {
    showDialog(
      context: context,
      builder: (context) => LoginDialog(),
    ).then((_) => setState(() {}));
  }
}

// Home Screen
class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final DataManager _dataManager = DataManager();

  @override
  Widget build(BuildContext context) {
    final stats = _dataManager.getStats();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'E-Ehson Global v36',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        backgroundColor: Colors.blue.shade600,
        elevation: 0,
        actions: [
          if (_dataManager.currentUser != null)
            Padding(
              padding: EdgeInsets.only(right: 16),
              child: Center(
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Text(
                    '${_dataManager.currentUser!.firstName[0]}${_dataManager.currentUser!.lastName[0]}',
                    style: TextStyle(
                      color: Colors.blue.shade600,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Hero Section
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.blue.shade600, Colors.blue.shade800],
                ),
              ),
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  children: [
                    Text(
                      'Dunyoni O\'zgartiring',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Professional xayriya platformasi orqali yaxshi ishlarni qo\'llab-quvvatlang',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white70,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 30),
                    // Stats Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildStatItem(
                            'Jami Xayriya',
                            '${_formatCurrency(stats['totalDonations'])}',
                            Icons.monetization_on),
                        _buildStatItem('Foydalanuvchilar',
                            '${stats['totalUsers']}', Icons.people),
                        _buildStatItem('Kampaniyalar',
                            '${stats['activeCampaigns']}', Icons.campaign),
                      ],
                    ),
                    SizedBox(height: 30),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => CampaignsScreen()),
                              );
                            },
                            child: Text('Xayriya Qilish'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: Colors.blue.shade600,
                              padding: EdgeInsets.symmetric(vertical: 15),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 15),
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () {
                              if (_dataManager.currentUser != null) {
                                _showCreateCampaignDialog();
                              } else {
                                _showLoginDialog();
                              }
                            },
                            child: Text('Kampaniya Yaratish'),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.white,
                              side: BorderSide(color: Colors.white),
                              padding: EdgeInsets.symmetric(vertical: 15),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Categories Section
            Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Kategoriyalar',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 15),
                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    crossAxisSpacing: 15,
                    mainAxisSpacing: 15,
                    children: [
                      _buildCategoryCard(
                          'Tibbiyot', '🏥', Colors.red.shade100, Colors.red),
                      _buildCategoryCard(
                          'Ta\'lim', '📚', Colors.blue.shade100, Colors.blue),
                      _buildCategoryCard(
                          'Uy-Joy', '🏠', Colors.green.shade100, Colors.green),
                      _buildCategoryCard('Ijtimoiy', '🤝',
                          Colors.orange.shade100, Colors.orange),
                    ],
                  ),
                ],
              ),
            ),

            // Recent Campaigns
            Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'So\'ngi Kampaniyalar',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CampaignsScreen()),
                          );
                        },
                        child: Text('Barchasini ko\'rish'),
                      ),
                    ],
                  ),
                  SizedBox(height: 15),
                  Container(
                    height: 280,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _dataManager.campaigns.take(5).length,
                      itemBuilder: (context, index) {
                        final campaign = _dataManager.campaigns[index];
                        return Container(
                          width: 300,
                          margin: EdgeInsets.only(right: 15),
                          child: CampaignCard(campaign: campaign),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),

            // Live Activity
            Container(
              margin: EdgeInsets.all(20),
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          color: Colors.green,
                          shape: BoxShape.circle,
                        ),
                      ),
                      SizedBox(width: 10),
                      Text(
                        'Jonli Faoliyat',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 15),
                  ...List.generate(
                      3,
                      (index) => Padding(
                            padding: EdgeInsets.only(bottom: 10),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  radius: 15,
                                  backgroundColor: Colors.blue.shade100,
                                  child: Text('👤',
                                      style: TextStyle(fontSize: 12)),
                                ),
                                SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    'Foydalanuvchi ${index + 1} ${_formatCurrency(Random().nextInt(100000) + 10000)} xayriya qildi',
                                    style: TextStyle(fontSize: 14),
                                  ),
                                ),
                                Text(
                                  '${index + 1} daqiqa oldin',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                              ],
                            ),
                          )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String title, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 30),
        SizedBox(height: 5),
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        Text(
          title,
          style: TextStyle(
            fontSize: 12,
            color: Colors.white70,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildCategoryCard(
      String title, String emoji, Color bgColor, Color textColor) {
    return Container(
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: textColor.withOpacity(0.2)),
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  CampaignsScreen(category: title.toLowerCase()),
            ),
          );
        },
        borderRadius: BorderRadius.circular(15),
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                emoji,
                style: TextStyle(fontSize: 40),
              ),
              SizedBox(height: 10),
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatCurrency(double amount) {
    if (amount >= 1000000) {
      return '${(amount / 1000000).toStringAsFixed(1)}M';
    } else if (amount >= 1000) {
      return '${(amount / 1000).toStringAsFixed(1)}K';
    }
    return amount.toStringAsFixed(0);
  }

  void _showLoginDialog() {
    showDialog(
      context: context,
      builder: (context) => LoginDialog(),
    ).then((_) => setState(() {}));
  }

  void _showCreateCampaignDialog() {
    showDialog(
      context: context,
      builder: (context) => CreateCampaignDialog(),
    ).then((_) => setState(() {}));
  }
}

// Campaigns Screen
class CampaignsScreen extends StatefulWidget {
  final String? category;

  CampaignsScreen({this.category});

  @override
  _CampaignsScreenState createState() => _CampaignsScreenState();
}

class _CampaignsScreenState extends State<CampaignsScreen> {
  final DataManager _dataManager = DataManager();
  String _selectedCategory = 'Barchasi';
  String _sortBy = 'Eng yangi';

  @override
  Widget build(BuildContext context) {
    List<Campaign> filteredCampaigns = _dataManager.campaigns;

    if (_selectedCategory != 'Barchasi') {
      filteredCampaigns = filteredCampaigns
          .where((c) => c.category == _selectedCategory.toLowerCase())
          .toList();
    }

    // Sort campaigns
    switch (_sortBy) {
      case 'Eng yangi':
        filteredCampaigns.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        break;
      case 'Eng mashhur':
        filteredCampaigns.sort((a, b) => b.donors.compareTo(a.donors));
        break;
      case 'Shoshilinch':
        filteredCampaigns.sort((a, b) => a.daysLeft.compareTo(b.daysLeft));
        break;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Kampaniyalar'),
        backgroundColor: Colors.blue.shade600,
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              if (_dataManager.currentUser != null) {
                _showCreateCampaignDialog();
              } else {
                _showLoginDialog();
              }
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Filters
          Container(
            padding: EdgeInsets.all(15),
            color: Colors.grey.shade50,
            child: Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _selectedCategory,
                    decoration: InputDecoration(
                      labelText: 'Kategoriya',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                    ),
                    items: [
                      'Barchasi',
                      'Tibbiyot',
                      'Ta\'lim',
                      'Uy-joy',
                      'Ijtimoiy'
                    ]
                        .map((category) => DropdownMenuItem(
                              value: category,
                              child: Text(category),
                            ))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedCategory = value!;
                      });
                    },
                  ),
                ),
                SizedBox(width: 15),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _sortBy,
                    decoration: InputDecoration(
                      labelText: 'Saralash',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                    ),
                    items: ['Eng yangi', 'Eng mashhur', 'Shoshilinch']
                        .map((sort) => DropdownMenuItem(
                              value: sort,
                              child: Text(sort),
                            ))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        _sortBy = value!;
                      });
                    },
                  ),
                ),
              ],
            ),
          ),

          // Campaigns List
          Expanded(
            child: filteredCampaigns.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.campaign_outlined,
                          size: 80,
                          color: Colors.grey.shade400,
                        ),
                        SizedBox(height: 20),
                        Text(
                          'Kampaniyalar topilmadi',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: EdgeInsets.all(15),
                    itemCount: filteredCampaigns.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: EdgeInsets.only(bottom: 15),
                        child: CampaignCard(campaign: filteredCampaigns[index]),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  void _showCreateCampaignDialog() {
    showDialog(
      context: context,
      builder: (context) => CreateCampaignDialog(),
    ).then((_) => setState(() {}));
  }

  void _showLoginDialog() {
    showDialog(
      context: context,
      builder: (context) => LoginDialog(),
    ).then((_) => setState(() {}));
  }
}

// Campaign Card Widget
class CampaignCard extends StatelessWidget {
  final Campaign campaign;

  CampaignCard({required this.campaign});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CampaignDetailScreen(campaign: campaign),
            ),
          );
        },
        borderRadius: BorderRadius.circular(15),
        child: Padding(
          padding: EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    campaign.image,
                    style: TextStyle(fontSize: 30),
                  ),
                  SizedBox(width: 15),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          campaign.title,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 5),
                        Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: _getStatusColor(campaign.status)
                                .withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            _getStatusText(campaign.status),
                            style: TextStyle(
                              fontSize: 12,
                              color: _getStatusColor(campaign.status),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 15),
              Text(
                campaign.description,
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 14,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 15),

              // Progress Bar
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Yig\'ildi: ${_formatCurrency(campaign.currentAmount)}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        '${campaign.progressPercentage.toStringAsFixed(0)}%',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.blue.shade600,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  LinearProgressIndicator(
                    value: campaign.progressPercentage / 100,
                    backgroundColor: Colors.grey.shade200,
                    valueColor:
                        AlwaysStoppedAnimation<Color>(Colors.blue.shade600),
                    minHeight: 8,
                  ),
                  SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Maqsad: ${_formatCurrency(campaign.targetAmount)}',
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        campaign.daysLeft > 0
                            ? '${campaign.daysLeft} kun qoldi'
                            : 'Tugagan',
                        style: TextStyle(
                          color: campaign.daysLeft > 0
                              ? Colors.orange.shade600
                              : Colors.red.shade600,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${campaign.donors} xayriyachi',
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 14,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: campaign.status == 'active'
                        ? () {
                            _showDonationDialog(context, campaign);
                          }
                        : null,
                    child: Text('Yordam Berish'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue.shade600,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'active':
        return Colors.green;
      case 'completed':
        return Colors.blue;
      case 'pending':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  String _getStatusText(String status) {
    switch (status) {
      case 'active':
        return 'Faol';
      case 'completed':
        return 'Tugallangan';
      case 'pending':
        return 'Kutilmoqda';
      default:
        return 'Noma\'lum';
    }
  }

  String _formatCurrency(double amount) {
    if (amount >= 1000000) {
      return '${(amount / 1000000).toStringAsFixed(1)}M so\'m';
    } else if (amount >= 1000) {
      return '${(amount / 1000).toStringAsFixed(1)}K so\'m';
    }
    return '${amount.toStringAsFixed(0)} so\'m';
  }

  void _showDonationDialog(BuildContext context, Campaign campaign) {
    final dataManager = DataManager();
    if (dataManager.currentUser == null) {
      showDialog(
        context: context,
        builder: (context) => LoginDialog(),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) => DonationDialog(campaign: campaign),
    );
  }
}

// Campaign Detail Screen
class CampaignDetailScreen extends StatelessWidget {
  final Campaign campaign;

  CampaignDetailScreen({required this.campaign});

  @override
  Widget build(BuildContext context) {
    final dataManager = DataManager();
    final campaignDonations = dataManager.donations
        .where((d) => d.campaignId == campaign.id)
        .toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

    return Scaffold(
      appBar: AppBar(
        title: Text('Kampaniya Tafsilotlari'),
        backgroundColor: Colors.blue.shade600,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hero Section
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.blue.shade50, Colors.white],
                ),
              ),
              child: Column(
                children: [
                  Text(
                    campaign.image,
                    style: TextStyle(fontSize: 80),
                  ),
                  SizedBox(height: 15),
                  Text(
                    campaign.title,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 10),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: _getStatusColor(campaign.status).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Text(
                      _getStatusText(campaign.status),
                      style: TextStyle(
                        color: _getStatusColor(campaign.status),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Progress Section
            Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Maqsad: ${_formatCurrency(campaign.targetAmount)}',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  LinearProgressIndicator(
                    value: campaign.progressPercentage / 100,
                    backgroundColor: Colors.grey.shade200,
                    valueColor:
                        AlwaysStoppedAnimation<Color>(Colors.blue.shade600),
                    minHeight: 12,
                  ),
                  SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${_formatCurrency(campaign.currentAmount)}',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue.shade600,
                            ),
                          ),
                          Text(
                            'yig\'ildi',
                            style: TextStyle(color: Colors.grey.shade600),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '${campaign.progressPercentage.toStringAsFixed(0)}%',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.green.shade600,
                            ),
                          ),
                          Text(
                            'bajarildi',
                            style: TextStyle(color: Colors.grey.shade600),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade50,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.grey.shade200),
                          ),
                          child: Column(
                            children: [
                              Text(
                                '${campaign.donors}',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue.shade600,
                                ),
                              ),
                              Text(
                                'Xayriyachi',
                                style: TextStyle(color: Colors.grey.shade600),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(width: 15),
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade50,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.grey.shade200),
                          ),
                          child: Column(
                            children: [
                              Text(
                                '${campaign.daysLeft}',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: campaign.daysLeft > 0
                                      ? Colors.orange.shade600
                                      : Colors.red.shade600,
                                ),
                              ),
                              Text(
                                campaign.daysLeft > 0 ? 'Kun qoldi' : 'Tugagan',
                                style: TextStyle(color: Colors.grey.shade600),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Description
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Tavsif',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    campaign.description,
                    style: TextStyle(
                      fontSize: 16,
                      height: 1.5,
                      color: Colors.grey.shade700,
                    ),
                  ),
                ],
              ),
            ),

            // Recent Donations
            if (campaignDonations.isNotEmpty)
              Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'So\'ngi Xayriyalar',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 15),
                    ...campaignDonations.take(5).map((donation) {
                      final user = dataManager.users.firstWhere(
                        (u) => u.id == donation.userId,
                        orElse: () => User(
                          id: '',
                          firstName: 'Anonim',
                          lastName: '',
                          email: '',
                          phone: '',
                          userType: 'user',
                          status: 'active',
                          createdAt: DateTime.now(),
                        ),
                      );

                      return Container(
                        margin: EdgeInsets.only(bottom: 10),
                        padding: EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade50,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.grey.shade200),
                        ),
                        child: Row(
                          children: [
                            CircleAvatar(
                              backgroundColor: Colors.blue.shade100,
                              child: Text(
                                donation.anonymous
                                    ? '?'
                                    : '${user.firstName[0]}${user.lastName.isNotEmpty ? user.lastName[0] : ''}',
                                style: TextStyle(
                                  color: Colors.blue.shade600,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            SizedBox(width: 15),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    donation.anonymous
                                        ? 'Anonim xayriyachi'
                                        : '${user.firstName} ${user.lastName}',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  if (donation.comment != null &&
                                      donation.comment!.isNotEmpty)
                                    Text(
                                      donation.comment!,
                                      style: TextStyle(
                                        color: Colors.grey.shade600,
                                        fontSize: 14,
                                      ),
                                    ),
                                ],
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  _formatCurrency(donation.amount),
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green.shade600,
                                  ),
                                ),
                                Text(
                                  _formatDate(donation.createdAt),
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ],
                ),
              ),
          ],
        ),
      ),
      bottomNavigationBar: campaign.status == 'active'
          ? Container(
              padding: EdgeInsets.all(20),
              child: ElevatedButton(
                onPressed: () {
                  _showDonationDialog(context, campaign);
                },
                child: Text(
                  'Yordam Berish',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade600,
                  padding: EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            )
          : null,
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'active':
        return Colors.green;
      case 'completed':
        return Colors.blue;
      case 'pending':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  String _getStatusText(String status) {
    switch (status) {
      case 'active':
        return 'Faol';
      case 'completed':
        return 'Tugallangan';
      case 'pending':
        return 'Kutilmoqda';
      default:
        return 'Noma\'lum';
    }
  }

  String _formatCurrency(double amount) {
    if (amount >= 1000000) {
      return '${(amount / 1000000).toStringAsFixed(1)}M so\'m';
    } else if (amount >= 1000) {
      return '${(amount / 1000).toStringAsFixed(1)}K so\'m';
    }
    return '${amount.toStringAsFixed(0)} so\'m';
  }

  String _formatDate(DateTime date) {
    return '${date.day}.${date.month}.${date.year}';
  }

  void _showDonationDialog(BuildContext context, Campaign campaign) {
    final dataManager = DataManager();
    if (dataManager.currentUser == null) {
      showDialog(
        context: context,
        builder: (context) => LoginDialog(),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) => DonationDialog(campaign: campaign),
    );
  }
}

// Profile Screen
class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final DataManager _dataManager = DataManager();

  @override
  Widget build(BuildContext context) {
    final user = _dataManager.currentUser!;
    final userDonations = _dataManager.donations
        .where((d) => d.userId == user.id)
        .toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

    final totalDonated =
        userDonations.fold<double>(0, (sum, d) => sum + d.amount);

    return Scaffold(
      appBar: AppBar(
        title: Text('Profil'),
        backgroundColor: Colors.blue.shade600,
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              _showLogoutDialog();
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Profile Header
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(30),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.blue.shade600, Colors.blue.shade800],
                ),
              ),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.white,
                    child: Text(
                      '${user.firstName[0]}${user.lastName[0]}',
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue.shade600,
                      ),
                    ),
                  ),
                  SizedBox(height: 15),
                  Text(
                    '${user.firstName} ${user.lastName}',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    user.email,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white70,
                    ),
                  ),
                  SizedBox(height: 10),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Text(
                      _getUserTypeText(user.userType),
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Stats
            Padding(
              padding: EdgeInsets.all(20),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.green.shade50,
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(color: Colors.green.shade200),
                      ),
                      child: Column(
                        children: [
                          Text(
                            '${_formatCurrency(totalDonated)}',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.green.shade600,
                            ),
                          ),
                          Text(
                            'Jami Xayriya',
                            style: TextStyle(color: Colors.grey.shade600),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: 15),
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(color: Colors.blue.shade200),
                      ),
                      child: Column(
                        children: [
                          Text(
                            '${userDonations.length}',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue.shade600,
                            ),
                          ),
                          Text(
                            'Xayriyalar',
                            style: TextStyle(color: Colors.grey.shade600),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // User Info
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Shaxsiy Ma\'lumotlar',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 15),
                  _buildInfoCard('Telefon', user.phone, Icons.phone),
                  _buildInfoCard('Email', user.email, Icons.email),
                  _buildInfoCard('Ro\'yxatdan o\'tgan',
                      _formatDate(user.createdAt), Icons.calendar_today),
                  if (user.organizationName != null)
                    _buildInfoCard(
                        'Tashkilot', user.organizationName!, Icons.business),
                ],
              ),
            ),

            // Recent Donations
            if (userDonations.isNotEmpty)
              Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'So\'ngi Xayriyalar',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 15),
                    ...userDonations.take(5).map((donation) {
                      final campaign = _dataManager.campaigns.firstWhere(
                        (c) => c.id == donation.campaignId,
                        orElse: () => Campaign(
                          id: '',
                          title: 'Noma\'lum kampaniya',
                          description: '',
                          targetAmount: 0,
                          status: 'active',
                          category: '',
                          image: '❓',
                          createdAt: DateTime.now(),
                          endDate: DateTime.now(),
                          createdBy: '',
                        ),
                      );

                      return Container(
                        margin: EdgeInsets.only(bottom: 10),
                        padding: EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade50,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.grey.shade200),
                        ),
                        child: Row(
                          children: [
                            Text(
                              campaign.image,
                              style: TextStyle(fontSize: 30),
                            ),
                            SizedBox(width: 15),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    campaign.title,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  if (donation.comment != null &&
                                      donation.comment!.isNotEmpty)
                                    Text(
                                      donation.comment!,
                                      style: TextStyle(
                                        color: Colors.grey.shade600,
                                        fontSize: 14,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                ],
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  _formatCurrency(donation.amount),
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green.shade600,
                                  ),
                                ),
                                Text(
                                  _formatDate(donation.createdAt),
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(String title, String value, IconData icon) {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.blue.shade600),
          SizedBox(width: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                ),
              ),
              Text(
                value,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _getUserTypeText(String userType) {
    switch (userType) {
      case 'admin':
        return 'Administrator';
      case 'creator':
        return 'Kampaniya Yaratuvchi';
      case 'volunteer':
        return 'Ko\'ngilli';
      default:
        return 'Foydalanuvchi';
    }
  }

  String _formatCurrency(double amount) {
    if (amount >= 1000000) {
      return '${(amount / 1000000).toStringAsFixed(1)}M so\'m';
    } else if (amount >= 1000) {
      return '${(amount / 1000).toStringAsFixed(1)}K so\'m';
    }
    return '${amount.toStringAsFixed(0)} so\'m';
  }

  String _formatDate(DateTime date) {
    return '${date.day}.${date.month}.${date.year}';
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Chiqish'),
        content: Text('Haqiqatan ham tizimdan chiqmoqchimisiz?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Bekor qilish'),
          ),
          ElevatedButton(
            onPressed: () {
              _dataManager.logout();
              Navigator.pop(context);
              setState(() {});
            },
            child: Text('Chiqish'),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
          ),
        ],
      ),
    );
  }
}

// Admin Screen
class AdminScreen extends StatefulWidget {
  @override
  _AdminScreenState createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  final DataManager _dataManager = DataManager();
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final stats = _dataManager.getStats();

    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Panel v36'),
        backgroundColor: Colors.indigo.shade600,
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              setState(() {});
            },
          ),
        ],
      ),
      body: Row(
        children: [
          // Sidebar
          Container(
            width: 250,
            color: Colors.indigo.shade900,
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundColor: Colors.white,
                        child: Text(
                          '${_dataManager.currentUser!.firstName[0]}${_dataManager.currentUser!.lastName[0]}',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.indigo.shade600,
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        '${_dataManager.currentUser!.firstName} ${_dataManager.currentUser!.lastName}',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        'Super Admin',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView(
                    children: [
                      _buildSidebarItem(0, Icons.dashboard, 'Dashboard'),
                      _buildSidebarItem(1, Icons.people, 'Foydalanuvchilar'),
                      _buildSidebarItem(2, Icons.campaign, 'Kampaniyalar'),
                      _buildSidebarItem(3, Icons.monetization_on, 'Xayriyalar'),
                      _buildSidebarItem(4, Icons.analytics, 'Analitika'),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Main Content
          Expanded(
            child: _buildMainContent(stats),
          ),
        ],
      ),
    );
  }

  Widget _buildSidebarItem(int index, IconData icon, String title) {
    final isSelected = _selectedIndex == index;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 2),
      child: ListTile(
        leading: Icon(icon, color: isSelected ? Colors.white : Colors.white70),
        title: Text(
          title,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.white70,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        selected: isSelected,
        selectedTileColor: Colors.indigo.shade700,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        onTap: () {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }

  Widget _buildMainContent(Map<String, dynamic> stats) {
    switch (_selectedIndex) {
      case 0:
        return _buildDashboard(stats);
      case 1:
        return _buildUsersManagement();
      case 2:
        return _buildCampaignsManagement();
      case 3:
        return _buildDonationsManagement();
      case 4:
        return _buildAnalytics(stats);
      default:
        return _buildDashboard(stats);
    }
  }

  Widget _buildDashboard(Map<String, dynamic> stats) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Dashboard',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 20),

          // Stats Cards
          GridView.count(
            crossAxisCount: 4,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            crossAxisSpacing: 15,
            mainAxisSpacing: 15,
            children: [
              _buildStatCard(
                'Jami Foydalanuvchilar',
                '${stats['totalUsers']}',
                Icons.people,
                Colors.blue,
                '+12% bu oy',
              ),
              _buildStatCard(
                'Faol Kampaniyalar',
                '${stats['activeCampaigns']}',
                Icons.campaign,
                Colors.green,
                '+8% bu oy',
              ),
              _buildStatCard(
                'Jami Xayriya',
                _formatCurrency(stats['totalDonations']),
                Icons.monetization_on,
                Colors.purple,
                '+15% bu oy',
              ),
              _buildStatCard(
                'Bugungi Xayriya',
                _formatCurrency(stats['todayDonations']),
                Icons.today,
                Colors.orange,
                '+5% kecha',
              ),
            ],
          ),

          SizedBox(height: 30),

          Row(
            children: [
              // Recent Activity
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.shade200,
                        blurRadius: 10,
                        offset: Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'So\'ngi Faoliyat',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 15),
                      Container(
                        height: 300,
                        child: ListView.builder(
                          itemCount: _dataManager.donations.length.clamp(0, 5),
                          itemBuilder: (context, index) {
                            final donation = _dataManager.donations[index];
                            final user = _dataManager.users.firstWhere(
                              (u) => u.id == donation.userId,
                              orElse: () => User(
                                id: '',
                                firstName: 'Anonim',
                                lastName: '',
                                email: '',
                                phone: '',
                                userType: 'user',
                                status: 'active',
                                createdAt: DateTime.now(),
                              ),
                            );

                            return ListTile(
                              leading: CircleAvatar(
                                backgroundColor: Colors.green.shade100,
                                child: Icon(Icons.monetization_on,
                                    color: Colors.green),
                              ),
                              title: Text('${user.firstName} ${user.lastName}'),
                              subtitle: Text(_formatCurrency(donation.amount)),
                              trailing: Text(
                                _formatDate(donation.createdAt),
                                style: TextStyle(fontSize: 12),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(width: 20),

              // Top Campaigns
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.shade200,
                        blurRadius: 10,
                        offset: Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Top Kampaniyalar',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 15),
                      Container(
                        height: 300,
                        child: ListView.builder(
                          itemCount: _dataManager.campaigns.length.clamp(0, 5),
                          itemBuilder: (context, index) {
                            final campaign = _dataManager.campaigns[index];

                            return ListTile(
                              leading: Text(
                                campaign.image,
                                style: TextStyle(fontSize: 24),
                              ),
                              title: Text(
                                campaign.title,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              subtitle: Text('${campaign.donors} xayriyachi'),
                              trailing: Text(
                                _formatCurrency(campaign.currentAmount),
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
      String title, String value, IconData icon, Color color, String change) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, color: color, size: 30),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.green.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  change,
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.green.shade700,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 15),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUsersManagement() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Foydalanuvchilar Boshqaruvi',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              ElevatedButton.icon(
                onPressed: () {
                  // Add user functionality
                },
                icon: Icon(Icons.add),
                label: Text('Yangi Foydalanuvchi'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade600,
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.shade200,
                  blurRadius: 10,
                  offset: Offset(0, 5),
                ),
              ],
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: [
                  DataColumn(label: Text('ID')),
                  DataColumn(label: Text('Ism Familiya')),
                  DataColumn(label: Text('Email')),
                  DataColumn(label: Text('Telefon')),
                  DataColumn(label: Text('Turi')),
                  DataColumn(label: Text('Holati')),
                  DataColumn(label: Text('Ro\'yxatdan o\'tgan')),
                  DataColumn(label: Text('Amallar')),
                ],
                rows: _dataManager.users
                    .map((user) => DataRow(
                          cells: [
                            DataCell(Text(user.id.substring(0, 8))),
                            DataCell(
                                Text('${user.firstName} ${user.lastName}')),
                            DataCell(Text(user.email)),
                            DataCell(Text(user.phone)),
                            DataCell(Text(_getUserTypeText(user.userType))),
                            DataCell(
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: user.status == 'active'
                                      ? Colors.green.shade100
                                      : Colors.red.shade100,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  user.status == 'active' ? 'Faol' : 'Nofaol',
                                  style: TextStyle(
                                    color: user.status == 'active'
                                        ? Colors.green.shade700
                                        : Colors.red.shade700,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ),
                            DataCell(Text(_formatDate(user.createdAt))),
                            DataCell(
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.edit, color: Colors.blue),
                                    onPressed: () {
                                      // Edit user functionality
                                    },
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.delete, color: Colors.red),
                                    onPressed: () {
                                      // Delete user functionality
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ))
                    .toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCampaignsManagement() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Kampaniyalar Boshqaruvi',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              ElevatedButton.icon(
                onPressed: () {
                  _showCreateCampaignDialog();
                },
                icon: Icon(Icons.add),
                label: Text('Yangi Kampaniya'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green.shade600,
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          GridView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 15,
              mainAxisSpacing: 15,
              childAspectRatio: 1.2,
            ),
            itemCount: _dataManager.campaigns.length,
            itemBuilder: (context, index) {
              final campaign = _dataManager.campaigns[index];
              return Container(
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.shade200,
                      blurRadius: 10,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(campaign.image, style: TextStyle(fontSize: 30)),
                        SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            campaign.title,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    LinearProgressIndicator(
                      value: campaign.progressPercentage / 100,
                      backgroundColor: Colors.grey.shade200,
                      valueColor:
                          AlwaysStoppedAnimation<Color>(Colors.blue.shade600),
                    ),
                    SizedBox(height: 10),
                    Text(
                      '${campaign.progressPercentage.toStringAsFixed(0)}% - ${_formatCurrency(campaign.currentAmount)}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.blue.shade600,
                      ),
                    ),
                    Text(
                      'Maqsad: ${_formatCurrency(campaign.targetAmount)}',
                      style:
                          TextStyle(color: Colors.grey.shade600, fontSize: 12),
                    ),
                    Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: _getStatusColor(campaign.status)
                                .withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            _getStatusText(campaign.status),
                            style: TextStyle(
                              color: _getStatusColor(campaign.status),
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            IconButton(
                              icon: Icon(Icons.edit, size: 20),
                              onPressed: () {
                                // Edit campaign
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.delete,
                                  size: 20, color: Colors.red),
                              onPressed: () {
                                // Delete campaign
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDonationsManagement() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Xayriyalar Boshqaruvi',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 20),

          // Stats Row
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: Colors.blue.shade200),
                  ),
                  child: Column(
                    children: [
                      Text(
                        'Bugungi Xayriyalar',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.blue.shade800,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        _formatCurrency(
                            _dataManager.getStats()['todayDonations']),
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(width: 15),
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.green.shade50,
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: Colors.green.shade200),
                  ),
                  child: Column(
                    children: [
                      Text(
                        'Jami Xayriyalar',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.green.shade800,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        '${_dataManager.donations.length}',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.green.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(width: 15),
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.purple.shade50,
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: Colors.purple.shade200),
                  ),
                  child: Column(
                    children: [
                      Text(
                        'Jami Miqdor',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.purple.shade800,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        _formatCurrency(
                            _dataManager.getStats()['totalDonations']),
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.purple.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: 30),

          // Donations Table
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.shade200,
                  blurRadius: 10,
                  offset: Offset(0, 5),
                ),
              ],
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: [
                  DataColumn(label: Text('ID')),
                  DataColumn(label: Text('Xayriyachi')),
                  DataColumn(label: Text('Kampaniya')),
                  DataColumn(label: Text('Miqdor')),
                  DataColumn(label: Text('To\'lov usuli')),
                  DataColumn(label: Text('Sana')),
                  DataColumn(label: Text('Izoh')),
                ],
                rows: _dataManager.donations.map((donation) {
                  final user = _dataManager.users.firstWhere(
                    (u) => u.id == donation.userId,
                    orElse: () => User(
                      id: '',
                      firstName: 'Anonim',
                      lastName: '',
                      email: '',
                      phone: '',
                      userType: 'user',
                      status: 'active',
                      createdAt: DateTime.now(),
                    ),
                  );

                  final campaign = _dataManager.campaigns.firstWhere(
                    (c) => c.id == donation.campaignId,
                    orElse: () => Campaign(
                      id: '',
                      title: 'Noma\'lum',
                      description: '',
                      targetAmount: 0,
                      status: 'active',
                      category: '',
                      image: '❓',
                      createdAt: DateTime.now(),
                      endDate: DateTime.now(),
                      createdBy: '',
                    ),
                  );

                  return DataRow(
                    cells: [
                      DataCell(Text(donation.id.substring(0, 8))),
                      DataCell(Text(donation.anonymous
                          ? 'Anonim'
                          : '${user.firstName} ${user.lastName}')),
                      DataCell(Text(
                        campaign.title,
                        overflow: TextOverflow.ellipsis,
                      )),
                      DataCell(Text(
                        _formatCurrency(donation.amount),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.green.shade600,
                        ),
                      )),
                      DataCell(Text(donation.paymentMethod.toUpperCase())),
                      DataCell(Text(_formatDate(donation.createdAt))),
                      DataCell(Text(
                        donation.comment ?? '-',
                        overflow: TextOverflow.ellipsis,
                      )),
                    ],
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnalytics(Map<String, dynamic> stats) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Analitika va Statistika',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 20),

          // Overview Cards
          GridView.count(
            crossAxisCount: 3,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            crossAxisSpacing: 15,
            mainAxisSpacing: 15,
            children: [
              _buildAnalyticsCard(
                'O\'rtacha Xayriya',
                _formatCurrency(stats['totalDonations'] /
                    (stats['totalUsers'] > 0 ? stats['totalUsers'] : 1)),
                Icons.trending_up,
                Colors.blue,
              ),
              _buildAnalyticsCard(
                'Muvaffaqiyat Darajasi',
                '${((stats['completedCampaigns'] / (stats['totalCampaigns'] > 0 ? stats['totalCampaigns'] : 1)) * 100).toStringAsFixed(1)}%',
                Icons.check_circle,
                Colors.green,
              ),
              _buildAnalyticsCard(
                'Faol Foydalanuvchilar',
                '${(stats['totalUsers'] * 0.7).toInt()}',
                Icons.people_alt,
                Colors.orange,
              ),
            ],
          ),

          SizedBox(height: 30),

          // Category Analysis
          Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.shade200,
                  blurRadius: 10,
                  offset: Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Kategoriya bo\'yicha Tahlil',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 20),

                // Category breakdown
                ...['tibbiyot', 'ta\'lim', 'uy-joy', 'ijtimoiy']
                    .map((category) {
                  final categoryCampaigns = _dataManager.campaigns
                      .where((c) => c.category == category)
                      .toList();
                  final totalAmount = categoryCampaigns.fold<double>(
                      0, (sum, c) => sum + c.currentAmount);

                  return Padding(
                    padding: EdgeInsets.only(bottom: 15),
                    child: Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: _getCategoryColor(category).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Center(
                            child: Text(
                              _getCategoryIcon(category),
                              style: TextStyle(fontSize: 20),
                            ),
                          ),
                        ),
                        SizedBox(width: 15),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _getCategoryName(category),
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                '${categoryCampaigns.length} kampaniya',
                                style: TextStyle(
                                  color: Colors.grey.shade600,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          _formatCurrency(totalAmount),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: _getCategoryColor(category),
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnalyticsCard(
      String title, String value, IconData icon, Color color) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 40),
          SizedBox(height: 15),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade600,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'tibbiyot':
        return Colors.red;
      case 'ta\'lim':
        return Colors.blue;
      case 'uy-joy':
        return Colors.green;
      case 'ijtimoiy':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  String _getCategoryIcon(String category) {
    switch (category) {
      case 'tibbiyot':
        return '🏥';
      case 'ta\'lim':
        return '📚';
      case 'uy-joy':
        return '🏠';
      case 'ijtimoiy':
        return '🤝';
      default:
        return '❓';
    }
  }

  String _getCategoryName(String category) {
    switch (category) {
      case 'tibbiyot':
        return 'Tibbiyot';
      case 'ta\'lim':
        return 'Ta\'lim';
      case 'uy-joy':
        return 'Uy-Joy';
      case 'ijtimoiy':
        return 'Ijtimoiy';
      default:
        return 'Boshqa';
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'active':
        return Colors.green;
      case 'completed':
        return Colors.blue;
      case 'pending':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  String _getStatusText(String status) {
    switch (status) {
      case 'active':
        return 'Faol';
      case 'completed':
        return 'Tugallangan';
      case 'pending':
        return 'Kutilmoqda';
      default:
        return 'Noma\'lum';
    }
  }

  String _getUserTypeText(String userType) {
    switch (userType) {
      case 'admin':
        return 'Admin';
      case 'creator':
        return 'Yaratuvchi';
      case 'volunteer':
        return 'Ko\'ngilli';
      default:
        return 'Foydalanuvchi';
    }
  }

  String _formatCurrency(double amount) {
    if (amount >= 1000000) {
      return '${(amount / 1000000).toStringAsFixed(1)}M so\'m';
    } else if (amount >= 1000) {
      return '${(amount / 1000).toStringAsFixed(1)}K so\'m';
    }
    return '${amount.toStringAsFixed(0)} so\'m';
  }

  String _formatDate(DateTime date) {
    return '${date.day}.${date.month}.${date.year}';
  }

  void _showCreateCampaignDialog() {
    showDialog(
      context: context,
      builder: (context) => CreateCampaignDialog(),
    ).then((_) => setState(() {}));
  }
}

// Login Dialog
class LoginDialog extends StatefulWidget {
  @override
  _LoginDialogState createState() => _LoginDialogState();
}

class _LoginDialogState extends State<LoginDialog> {
  final _formKey = GlobalKey<FormState>();
  final _identifierController = TextEditingController();
  final _passwordController = TextEditingController();
  final DataManager _dataManager = DataManager();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Tizimga Kirish'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _identifierController,
              decoration: InputDecoration(
                labelText: 'Email yoki Telefon',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.person),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Email yoki telefon kiriting';
                }
                return null;
              },
            ),
            SizedBox(height: 15),
            TextFormField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: 'Parol',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.lock),
              ),
              obscureText: true,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Parol kiriting';
                }
                return null;
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Bekor qilish'),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context);
            showDialog(
              context: context,
              builder: (context) => RegisterDialog(),
            );
          },
          child: Text('Ro\'yxatdan o\'tish'),
        ),
        ElevatedButton(
          onPressed: _isLoading ? null : _login,
          child: _isLoading
              ? SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Text('Kirish'),
        ),
      ],
    );
  }

  void _login() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      // Simulate login (in real app, you'd validate password)
      final user = _dataManager.login(
          _identifierController.text, _passwordController.text);

      if (user != null) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Xush kelibsiz, ${user.firstName}!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
}

// Register Dialog
class RegisterDialog extends StatefulWidget {
  @override
  _RegisterDialogState createState() => _RegisterDialogState();
}

class _RegisterDialogState extends State<RegisterDialog> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final DataManager _dataManager = DataManager();

  String _userType = 'user';
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Ro\'yxatdan O\'tish'),
      content: Container(
        width: double.maxFinite,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButtonFormField<String>(
                  value: _userType,
                  decoration: InputDecoration(
                    labelText: 'Foydalanuvchi turi',
                    border: OutlineInputBorder(),
                  ),
                  items: [
                    DropdownMenuItem(
                        value: 'user',
                        child: Text('🙋‍♂️ Oddiy Foydalanuvchi')),
                    DropdownMenuItem(
                        value: 'creator',
                        child: Text('🎯 Kampaniya Yaratuvchi')),
                    DropdownMenuItem(
                        value: 'volunteer', child: Text('🤝 Ko\'ngilli')),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _userType = value!;
                    });
                  },
                ),
                SizedBox(height: 15),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _firstNameController,
                        decoration: InputDecoration(
                          labelText: 'Ism *',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Ism kiriting';
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: TextFormField(
                        controller: _lastNameController,
                        decoration: InputDecoration(
                          labelText: 'Familiya *',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Familiya kiriting';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 15),
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Email *',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.email),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Email kiriting';
                    }
                    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                        .hasMatch(value)) {
                      return 'To\'g\'ri email kiriting';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 15),
                TextFormField(
                  controller: _phoneController,
                  decoration: InputDecoration(
                    labelText: 'Telefon *',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.phone),
                    hintText: '+998 90 123 45 67',
                  ),
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Telefon raqam kiriting';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 15),
                TextFormField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    labelText: 'Parol *',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.lock),
                  ),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Parol kiriting';
                    }
                    if (value.length < 6) {
                      return 'Parol kamida 6 ta belgi bo\'lishi kerak';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 15),
                TextFormField(
                  controller: _confirmPasswordController,
                  decoration: InputDecoration(
                    labelText: 'Parolni tasdiqlash *',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.lock_outline),
                  ),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Parolni tasdiqlang';
                    }
                    if (value != _passwordController.text) {
                      return 'Parollar mos kelmaydi';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Bekor qilish'),
        ),
        ElevatedButton(
          onPressed: _isLoading ? null : _register,
          child: _isLoading
              ? SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Text('Ro\'yxatdan o\'tish'),
        ),
      ],
    );
  }

  void _register() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final userData = {
        'firstName': _firstNameController.text,
        'lastName': _lastNameController.text,
        'email': _emailController.text,
        'phone': _phoneController.text,
        'userType': _userType,
      };

      final user = _dataManager.register(userData);

      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'Ro\'yxatdan o\'tish muvaffaqiyatli! Endi tizimga kirishingiz mumkin.'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
}

// CreateCampaignDialog
class CreateCampaignDialog extends StatefulWidget {
  @override
  _CreateCampaignDialogState createState() => _CreateCampaignDialogState();
}

class _CreateCampaignDialogState extends State<CreateCampaignDialog> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _targetAmountController = TextEditingController();
  final _endDateController = TextEditingController();
  String _category = 'tibbiyot';
  final DataManager _dataManager = DataManager();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Yangi Kampaniya Yaratish'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _titleController,
              decoration: InputDecoration(labelText: 'Sarlavha'),
              validator: (value) => value!.isEmpty ? 'Sarlavha kiriting' : null,
            ),
            TextFormField(
              controller: _descriptionController,
              decoration: InputDecoration(labelText: 'Tavsif'),
              validator: (value) => value!.isEmpty ? 'Tavsif kiriting' : null,
            ),
            TextFormField(
              controller: _targetAmountController,
              decoration: InputDecoration(labelText: 'Maqsad summasi'),
              keyboardType: TextInputType.number,
              validator: (value) => value!.isEmpty ? 'Summasi kiriting' : null,
            ),
            TextFormField(
              controller: _endDateController,
              decoration:
                  InputDecoration(labelText: 'Tugash sanasi (YYYY-MM-DD)'),
              validator: (value) => value!.isEmpty ? 'Sana kiriting' : null,
            ),
            DropdownButtonFormField<String>(
              value: _category,
              decoration: InputDecoration(labelText: 'Kategoriya'),
              items: ['tibbiyot', 'ta\'lim', 'uy-joy', 'ijtimoiy']
                  .map((cat) => DropdownMenuItem(value: cat, child: Text(cat)))
                  .toList(),
              onChanged: (value) => setState(() => _category = value!),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(context), child: Text('Bekor')),
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              final campaignData = {
                'title': _titleController.text,
                'description': _descriptionController.text,
                'targetAmount': double.parse(_targetAmountController.text),
                'endDate': _endDateController.text,
                'category': _category,
              };
              _dataManager.createCampaign(campaignData);
              Navigator.pop(context);
            }
          },
          child: Text('Yaratish'),
        ),
      ],
    );
  }
}

// DonationDialog
class DonationDialog extends StatefulWidget {
  final Campaign campaign;

  DonationDialog({required this.campaign});

  @override
  _DonationDialogState createState() => _DonationDialogState();
}

class _DonationDialogState extends State<DonationDialog> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _commentController = TextEditingController();
  String _paymentMethod = 'card';
  bool _anonymous = false;
  final DataManager _dataManager = DataManager();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Xayriya Qilish'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _amountController,
              decoration: InputDecoration(labelText: 'Summa'),
              keyboardType: TextInputType.number,
              validator: (value) => value!.isEmpty ? 'Summa kiriting' : null,
            ),
            TextFormField(
              controller: _commentController,
              decoration: InputDecoration(labelText: 'Izoh (ixtiyoriy)'),
            ),
            DropdownButtonFormField<String>(
              value: _paymentMethod,
              decoration: InputDecoration(labelText: 'To\'lov usuli'),
              items: ['card', 'cash', 'transfer']
                  .map((method) =>
                      DropdownMenuItem(value: method, child: Text(method)))
                  .toList(),
              onChanged: (value) => setState(() => _paymentMethod = value!),
            ),
            CheckboxListTile(
              title: Text('Anonim'),
              value: _anonymous,
              onChanged: (value) => setState(() => _anonymous = value!),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(context), child: Text('Bekor')),
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              final donationData = {
                'campaignId': widget.campaign.id,
                'amount': double.parse(_amountController.text),
                'paymentMethod': _paymentMethod,
                'comment': _commentController.text,
                'anonymous': _anonymous,
              };
              _dataManager.makeDonation(donationData);
              Navigator.pop(context);
            }
          },
          child: Text('Yuborish'),
        ),
      ],
    );
  }
}
