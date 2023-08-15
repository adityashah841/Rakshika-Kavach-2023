import 'package:flutter/material.dart';
import 'package:women_safety_app/components/app_bar.dart';

class EFirAdmin extends StatefulWidget {
  const EFirAdmin({Key? key}) : super(key: key);

  @override
  _EFirAdminState createState() => _EFirAdminState();
}

class _EFirAdminState extends State<EFirAdmin> {
  String _selectedTab = 'Pending';

  final List<Map<String, dynamic>> _pendingRequests = [
     {
      'name': 'Krishi Shah',
      'crime': 'Theft',
      'location': '123 Borivali',
      'status': 'pending',
    },
     {
      'name': 'Anaida Lewis',
      'crime': 'Theft',
      'location': '123 Borivali',
      'status': 'pending',
    },
     {
      'name': 'Vidhi Kansara',
      'crime': 'Theft',
      'location': '123 Borivali',
      'status': 'pending',
    },
     {
      'name': 'Vijay Harkare',
      'crime': 'Theft',
      'location': '123 Borivali',
      'status': 'pending',
    },
     {
      'name': 'Rashi Shah',
      'crime': 'Theft',
      'location': '123 Borivali',
      'status': 'pending',
    },
     {
      'name': 'Krishi Shah',
      'crime': 'Theft',
      'location': '123 Borivali',
      'status': 'pending',
    },
     {
      'name': 'Krishi Shah',
      'crime': 'Theft',
      'location': '123 Borivali',
      'status': 'pending',
    },
     {
      'name': 'Krishi Shah',
      'crime': 'Theft',
      'location': '123 Borivali',
      'status': 'pending',
    },
     {
      'name': 'Krishi Shah',
      'crime': 'Theft',
      'location': '123 Borivali',
      'status': 'pending',
    },
     {
      'name': 'Krishi Shah',
      'crime': 'Theft',
      'location': '123 Borivali',
      'status': 'pending',
    },
    {
      'name': 'Krishi Shah',
      'crime': 'Theft',
      'location': '123 Borivali',
      'status': 'pending',
    },
     {
      'name': 'Krishi Shah',
      'crime': 'Theft',
      'location': '123 Borivali',
      'status': 'pending',
    },
     {
      'name': 'Krishi Shah',
      'crime': 'Theft',
      'location': '123 Borivali',
      'status': 'pending',
    },
     {
      'name': 'Krishi Shah',
      'crime': 'Theft',
      'location': '123 Borivali',
      'status': 'pending',
    },
     {
      'name': 'Krishi Shah',
      'crime': 'Theft',
      'location': '123 Borivali',
      'status': 'pending',
    },
     {
      'name': 'Krishi Shah',
      'crime': 'Theft',
      'location': '123 Borivali',
      'status': 'pending',
    },
     {
      'name': 'Krishi Shah',
      'crime': 'Theft',
      'location': '123 Borivali',
      'status': 'pending',
    },
     {
      'name': 'Krishi Shah',
      'crime': 'Theft',
      'location': '123 Borivali',
      'status': 'pending',
    },
     {
      'name': 'Krishi Shah',
      'crime': 'Theft',
      'location': '123 Borivali',
      'status': 'pending',
    },
     {
      'name': 'Krishi Shah',
      'crime': 'Theft',
      'location': '123 Borivali',
      'status': 'pending',
    },
  ];

  final List<Map<String, dynamic>> _completedRequests = [];
  final List<Map<String, dynamic>> _discardedRequests = [];

  void _moveRequestToCategory(int index, String category) {
    setState(() {
      final request = _pendingRequests[index];
      if (category == 'Completed') {
        request['status'] = 'completed';
        _completedRequests.add(request);
      } else if (category == 'Discarded') {
        request['status'] = 'discarded';
        _discardedRequests.add(request);
      }
      _pendingRequests.removeAt(index);
    });
  }

  Widget _buildRequestCard(Map<String, dynamic> request, int index) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        title: Text(request['name']),
        subtitle: Text(request['crime']),
        trailing: _selectedTab == 'Pending'
            ? Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(Icons.check, color: Colors.green),
                    onPressed: () => _moveRequestToCategory(index, 'Completed'),
                  ),
                  IconButton(
                    icon: Icon(Icons.close, color: Colors.red),
                    onPressed: () => _moveRequestToCategory(index, 'Discarded'),
                  ),
                ],
              )
            : null,
        onTap: () => _showRequestDetails(request),
      ),
    );
  }

  void _showRequestDetails(Map<String, dynamic> request) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Request Details'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Name: ${request['name']}'),
              Text('Crime: ${request['crime']}'),
              Text('Location: ${request['location']}'),
              // Add more details as needed
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }

  List<Widget> _buildRequestList(String category) {
    List<Map<String, dynamic>> requests = [];

    if (category == 'Pending') {
      requests = _pendingRequests;
    } else if (category == 'Completed') {
      requests = _completedRequests;
    } else if (category == 'Discarded') {
      requests = _discardedRequests;
    }

    return requests.map((request) {
      final index = requests.indexOf(request);
      return _buildRequestCard(request, index);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarConstant(),
      body: Column(
        children: [
          Container(
            decoration: const BoxDecoration(
              color: Colors.white,
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildTabButton('Pending'),
                  _buildTabButton('Completed'),
                  _buildTabButton('Discarded'),
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView(
              children: _buildRequestList(_selectedTab),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabButton(String tabName) {
    return TextButton(
      onPressed: () {
        setState(() {
          _selectedTab = tabName;
        });
      },
      child: Text(
        tabName,
        style: TextStyle(
          color: _selectedTab == tabName ? Colors.blue : Colors.black,
          fontWeight: _selectedTab == tabName ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }
}

