import 'package:flutter/material.dart';
import 'package:Rakshika/components/app_bar.dart';
import 'package:file_picker/file_picker.dart';
import '../utils/color.dart';
import 'package:http/http.dart' as http;
import 'package:Rakshika/main.dart';

class EFirFemaleScreen extends StatefulWidget {
  const EFirFemaleScreen({super.key});

  @override
  State<EFirFemaleScreen> createState() => _EFirFemaleScreenState();
}

class _EFirFemaleScreenState extends State<EFirFemaleScreen> {
  final TextEditingController _descriptionController = TextEditingController();
  String _selectedLocation = 'Location A'; // Default location
  String _audioFilePath = ''; // Store the selected audio file path
  String _videoFilePath = ''; // Store the selected video file path

  Future<void> fileEFir(String? authToken, String crime_description, String location, String audioFilePath, String videoFilePath) async {
    // Create a multipart request
    var request = http.MultipartRequest('POST', Uri.parse('https://rakshika.onrender.com/efir/file_efir/'));
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $authToken',
    };
    request.headers.addAll(headers);
    // Attach the audio file or an empty field
    if (audioFilePath != '') {
      // var audioFile = await http.MultipartFile.fromPath('audio', audioFilePath);
      request.files.add(await http.MultipartFile.fromPath('audio', audioFilePath));
    }
    
    // Attach the video file or an empty field
    if (videoFilePath != '') {
      // var videoFile = await http.MultipartFile.fromPath('video', videoFilePath);
      request.files.add(await http.MultipartFile.fromPath('video', videoFilePath));
    }

    request.fields['location'] = location;
    request.fields['crime_description'] = crime_description;
    
    // Send the request
    var response = await request.send();
    
    // Check the response status code
    if (response.statusCode == 201) {
      print('Files uploaded successfully');
    } else {
      print('Failed to upload files');
      print(response.reasonPhrase);
      print(response.stream.toString());
      throw Exception('Failed to upload files');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const AppBarConstant(),
        backgroundColor: rBackground,
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  "Crime Description",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 5),
                TextFormField(
                  controller: _descriptionController,
                  maxLines: 5,
                  maxLength: 500,
                  decoration: InputDecoration(
                    hintText: "Enter the crime description",
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 42, vertical: 20),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(28),
                        borderSide: const BorderSide(color: Colors.black),
                        gapPadding: 10),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(28),
                        borderSide: const BorderSide(color: Colors.black),
                        gapPadding: 10),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  "Choose Location",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 5),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(28),
                    border: Border.all(color: Colors.black),
                  ),
                  child: DropdownButtonFormField<String>(
                    value: _selectedLocation,
                    items: ['Location A', 'Location B', 'Location C']
                        .map((location) => DropdownMenuItem<String>(
                              value: location,
                              child: Text(location),
                            ))
                        .toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedLocation = newValue ?? 'Select Location';
                      });
                    },
                    decoration: const InputDecoration.collapsed(
                      hintText: 'Select Location',
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  "Attach Audio",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 5),
                _buildAttachmentField("Attach Audio", _audioFilePath),
                const SizedBox(height: 16),
                const Text(
                  "Attach Video",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 5),
                _buildAttachmentField("Attach Video", _videoFilePath),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () async {
                    String? authToken = await storage.read(key: 'access_login');
                    await fileEFir(
                      authToken,
                      _descriptionController.text,
                      _selectedLocation,
                      _audioFilePath,
                      _videoFilePath,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Color(0xFF7A7AB6), // Set the background color
                  ),
                  child: const Text(
                    'Submit',
                    style: TextStyle(
                        color: Colors.white), // Set the text color to white
                  ),
                )
              ],
            ),
          ),
        ));
  }

  Widget _buildAttachmentField(String label, String filePath) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: Colors.black),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              filePath.isNotEmpty ? filePath : "No file attached",
              style: const TextStyle(color: Colors.grey),
            ),
          ),
          InkWell(
            onTap: () {
              _openFilePicker(label, filePath == _audioFilePath);
            },
            child: const Row(
              children: [
                Text(
                  "Attach",
                  style: TextStyle(color: Colors.black),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _openFilePicker(String label, bool isAudio) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.any, // Allow any type of file to be picked
    );
    if (result != null) {
      String filePath = result.files.single.path ?? '';
      setState(() {
        if (isAudio) {
          _audioFilePath = filePath;
        } else {
          _videoFilePath = filePath;
        }
      });
    }
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }
}
