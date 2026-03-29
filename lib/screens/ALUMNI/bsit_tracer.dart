import 'package:flutter/material.dart';
import 'package:signature/signature.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class BSITTracerPage extends StatefulWidget {
  final int userId;

  const BSITTracerPage({super.key, required this.userId});

  @override
  State<BSITTracerPage> createState() => _BSITTracerPageState();
}


class _BSITTracerPageState extends State<BSITTracerPage> {
  final _formKey = GlobalKey<FormState>();


  /// CONTROLLERS
  final name = TextEditingController();
  final age = TextEditingController();
  final email = TextEditingController();
  final address = TextEditingController();
  final contact = TextEditingController();
  final honors = TextEditingController();
  final otherReason = TextEditingController();
  final otherCountry = TextEditingController();
  final licensureType = TextEditingController();
  final studyProgram = TextEditingController();
  final studyInstitution = TextEditingController();
  final feedback1 = TextEditingController();
  final feedback2 = TextEditingController();
  final feedback3 = TextEditingController();
  final jobTitleController = TextEditingController();
  final companyController = TextEditingController();
  TextEditingController dateController = TextEditingController();


  String? sex, civil_status, studyMode, preGrad;
  String? employment, unemploymentReason, firstJob, firstRelated;
  String? empType, sector, country, income, jobRelated;
  String? notRelatedReason, duration, promoted, wantMore, moreReason;
  String? classification;
  String? skillUse;        
  String? overqualified;
  String? furtherStudy, studyType, studyRelated;
  String? licensureTaken, licensureResult, cpd;
  String? reputation, alumni;

  // SLIDERS
  double jobSatisfaction = 1;
  // Change your SLIDERS section to this:
double peo1 = 1, peo2 = 1, peo3 = 1, peo4 = 1, peo5 = 1, peo6 = 1;
double peo7 = 1, peo8 = 1, peo9 = 1, peo10 = 1, peo11 = 1;
  double curriculum = 1, faculty = 1, practicum = 1;
  double resources = 1, guidance = 1, career = 1;
  double admin = 1, overall = 1;

  double recommendation = 1;

  bool isAgreed = false;

  List<String> skills = [];

  final signature = SignatureController(
    penStrokeWidth: 3,
    penColor: Colors.black,
  );

  final skillList = [
    "Programming and Software Development",
    "Database Management",
    "Networking and Cybersecurity",
    "Systems Analysis and Design",
    "Cloud Computing and DevOps",
    "Problem-Solving and Critical Thinking",
    "Debugging and Troubleshooting",
    "Communication Skills",
    "Teamwork and Collaboration",
    "Time Management and Work Ethics",
    "Adaptability and Continuous Learning",
    "UI/UX Design",
    "Version Control (Git)",
    "AI / Data Analytics"
  ];

   @override
  void dispose() {
    // Dispose all controllers here
    dateController.dispose();
    signature.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F9),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 30),
            child: Column(
              children: [

                /// 🔷 HEADER
                header(),

                /// 🔷 A
                sectionTitle("A. Graduate Profile"),
            input("1. Full Name", name),
            input("2. Age", age, isNumber: true),
            dropdown("3. Sex", ["Male","Female","Prefer not"], (v)=>sex=v),
            input("4. Email", email, isEmail: true),
            input("5. Address", address),
            input("6. Contact", contact),
            input("8. Honors/Awards", honors),
            dropdown("9. Pre-graduation Experience",
              ["None","Internship","Part-time","Full-time"], (v)=>preGrad=v),
            dropdown("10. Study Mode",
              ["Regular","Distance/Online","Mixed"], (v)=>studyMode=v),

  sectionTitle("B. Employment"),
dropdown("11. Employment Status", 
  ["Employed", "Self-Employed", "Employer", "Unemployed", "Studying Full-Time"], 
  (v) {
    setState(() {
      employment = v;
      // Reset dependent fields when status changes to avoid submitting "ghost" data
      if (employment == "Unemployed") {
        // Clear employment-related variables here if necessary
      } else {
        unemploymentReason = null;
      }
    });
  }
),

// --- CONDITIONAL LOGIC STARTS HERE ---

if (employment == "Unemployed") ...[
  // Display ONLY Question 12 if Unemployed
  dropdown("12. Reason (if unemployed)",
    ["Further study", "Family/health reasons", "Lack of job opportunities", "Relocation", "Others"], 
    (v) => setState(() => unemploymentReason = v)
  ),
] 

else if (employment != null && employment != "Unemployed") ...[
  // Display all other questions ONLY if NOT Unemployed
  dropdown("13. First Job Time",
    ["<1 month", "1–3 months", "4–6 months", "7–12 months", ">1 year"], (v) => firstJob = v),

  dropdown("14. First Job Related",
    ["Yes", "Partly", "No"], (v) => firstRelated = v),

  dropdown("15. Employment Type",
    ["Full-time", "Part-time", "Project-based", "Freelance"], (v) => empType = v),

  input("16. Job Title", jobTitleController),
  input("17. Company", companyController),

  dropdown("18. Sector",
    ["Government", "Private", "NGO", "Academic", "Overseas"], (v) => setState(() => sector = v)),

  dropdown("19. Country",
    ["Philippines", "Other"], (v) => setState(() => country = v)),

  if (country == "Other") 
    input("Specify Country", otherCountry),

  dropdown("20. Income",
    ["<15k", "15–25k", "25–35k", "35–50k", "50–75k", ">75k"], (v) => income = v),

  dropdown("21. Job Related",
    ["Yes", "Somewhat", "No"], (v) => setState(() => jobRelated = v)),

  // Nested logic: Only show "Reason Not Related" if 21 is "No"
  if (jobRelated == "No")
    dropdown("22. Reason Not Related",
      ["No jobs", "Better pay", "Lack of experience", "Location", "Satisfaction"], (v) => notRelatedReason = v),

  dropdown("23. Duration",
    ["<6 months", "6–12 months", "1–2 years", "3+ years"], (v) => duration = v),

  dropdown("24. Promoted", ["Yes", "No"], (v) => promoted = v),

  dropdown("25. Want More Hours", ["Yes", "No"], (v) => wantMore = v),

  slider("26. Job Satisfaction", jobSatisfaction, (v) => setState(() => jobSatisfaction = v)),
],

                 // C
           sectionTitle("C. Skills"),

label("27. How much do you use your college-acquired skills in your current job?"),
checkboxRow(["1 Not at all", "2 Slightly", "3 Moderately", "4 Mostly", "5 Fully"], 
  skillUse, (v) => setState(() => skillUse = v)),

const SizedBox(height: 20),

label("28. Do you consider yourself overqualified or underutilized for your current position?"),
checkboxRow(["No", "Slightly", "Somewhat", "Much", "Very much"], 
  overqualified, (v) => setState(() => overqualified = v)),
  

            label("29. Top competencies you use at work (check all that apply):"),

Wrap(
  spacing: 8.0, // Gap between adjacent chips
  runSpacing: 4.0, // Gap between lines
  children: skillList.map((s) {
    bool isSelected = skills.contains(s);
    return InkWell(
      onTap: () {
        setState(() {
          isSelected ? skills.remove(s) : skills.add(s);
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        // Optional: add a border or background if you want them to look like buttons
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isSelected ? Icons.check_box : Icons.check_box_outline_blank,
              color: isSelected ? const Color(0xFF4A152C) : Colors.grey,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(s, style: const TextStyle(fontSize: 14)),
          ],
        ),
      ),
    );
  }).toList(),
),
            dropdown("30. Main reason your skills might not be fully used",
              ["Job mismatch","No jobs","Limited experience","Satisfied","Financial"], (v)=>{}),

            dropdown("31. Employment classification",
              ["Rank-and-file","Supervisory","Managerial","Executive"], (v)=>classification=v),

                // D
            sectionTitle("D. Further Studies"),

dropdown("32. Further Study", ["Yes","No"], (v) {
  setState(() => furtherStudy = v);
}),

if (furtherStudy == "Yes") ...[
  input("Program", studyProgram),
  input("Institution", studyInstitution),

  dropdown("33. Study Type", ["Certificate","MIT/MIS","PhD","Others"], (v) {
    setState(() => studyType = v);
  }),

  dropdown("34. Related to IT", ["Yes","No"], (v) {
    setState(() => studyRelated = v);
  }),

  dropdown("35. Licensure Taken", ["Yes","No"], (v) {
    setState(() => licensureTaken = v);
  }),

  if (licensureTaken == "Yes") ...[
    input("Licensure Type", licensureType),
    dropdown("Result", ["Passed","Did not pass","Pending"], (v) {
      setState(() => licensureResult = v);
    }),
  ],

  dropdown("36. CPD", ["Yes","No"], (v) {
    setState(() => cpd = v);
  }),
],

                // E
            sectionTitle("E. Attainment of Program Educational Objectives (PEOs)"),

slider(
  "37. Demonstrate a strong foundation in IT principles and practices",
  peo1,
  (v) => setState(() => peo1 = v),
),

slider(
  "38. Demonstrate leadership and innovation, taking initiative to lead projects, drive technological advancements, and contribute to organizational success",
  peo2,
  (v) => setState(() => peo2 = v),
),

slider(
  "39. Engage in continuous learning and professional development to adapt to the evolving field of information technology",
  peo3,
  (v) => setState(() => peo3 = v),
),


 // F. Satisfaction
sectionTitle("F. Satisfaction with Academic Preparation and Services"),

// Subtitle / instruction
Padding(
  padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
  child: Text(
    "Rate your satisfaction (1 = Very Dissatisfied to 5 = Very Satisfied):",
    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: Colors.grey[700]),
  ),
),

// 40. Curriculum relevance to IT practice
slider(
  "40. Curriculum relevance to IT practice",
  curriculum,
  (v) => setState(() => curriculum = v),
),

// 41. Quality of faculty instruction and mentorship
slider(
  "41. Quality of faculty instruction and mentorship",
  faculty,
  (v) => setState(() => faculty = v),
),

// 42. Field instruction / practicum supervision
slider(
  "42. Field instruction / practicum supervision",
  practicum,
  (v) => setState(() => practicum = v),
),

// 43. Library, Wi-Fi, and research resources
slider(
  "43. Library, Wi-Fi, and research resources",
  resources,
  (v) => setState(() => resources = v),
),

// 44. Guidance, counseling, and student support services
slider(
  "44. Guidance, counseling, and student support services",
  guidance,
  (v) => setState(() => guidance = v),
),

// 45. Career placement and alumni services
slider(
  "45. Career placement and alumni services",
  career,
  (v) => setState(() => career = v),
),

// 46. Administrative services and transactions
slider(
  "46. Administrative services and transactions",
  admin,
  (v) => setState(() => admin = v),
),

// 47. Overall satisfaction with JMCFI’s academic environment
slider(
  "47. Overall satisfaction with JMCFI’s academic environment",
  overall,
  (v) => setState(() => overall = v),
),

                 // G
           // G. Institutional Image and Alumni Engagement
sectionTitle("G. Institutional Image and Alumni Engagement"),

// 56. Recommendation
slider(
  "56. How likely are you to recommend JMCFI’s BSIT program to others? (0 = Not at all likely, 10 = Extremely likely)",
  recommendation,
  (v) => setState(() => recommendation = v),
  max: 10,
),

// 57. Reputation
dropdown(
  "57. How would you describe JMCFI’s reputation in the IT community?",
  ["Very negative", "Negative", "Neutral", "Positive", "Very positive"],
  (v) => setState(() => reputation = v),
),

// 58. Alumni Participation
dropdown(
  "58. Would you participate in alumni mentoring, outreach, or seminars?",
  ["Yes", "No"],
  (v) => setState(() => alumni = v),
),

            // H. Feedback and Continuous Improvement
sectionTitle("H. Feedback and Continuous Improvement"),

// 59. Competencies
textarea(
  "59. What specific competencies should be strengthened in the BSIT curriculum? (Open-ended)",
  feedback1,
),

// 60. Field Instruction
textarea(
  "60. What aspects of field instruction need improvement? (Open-ended)",
  feedback2,
),

// 61. Career Support
textarea(
  "61. How can JMCFI support alumni in career advancement and lifelong learning? (Open-ended)",
  feedback3,
),
/// 🔷 CONSENT
sectionTitle("I. Consent and Data Privacy"),

sectionCard([
  // Checkbox with description
  CheckboxListTile(
    value: isAgreed,
    onChanged: (v) => setState(() => isAgreed = v!),
    title: const Text(
      "I voluntarily agree that my data be used for institutional QA, program review, "
      "and accreditation purposes under RA 10173 (Data Privacy Act of 2012).",
      style: TextStyle(fontSize: 16), // same size as "I agree to Data Privacy"
    ),
    controlAffinity: ListTileControlAffinity.leading,
  ),
  const SizedBox(height: 10),

  // Signature container
  label("Signature (optional):"),
  Container(
    height: 120,
    decoration: BoxDecoration(
      border: Border.all(),
      borderRadius: BorderRadius.circular(8),
    ),
    child: Signature(controller: signature),
  ),
  const SizedBox(height: 10),

  // Date picker field
  TextFormField(
    controller: dateController, // declare this in your state class
    readOnly: true, // prevents typing
    decoration: const InputDecoration(
      labelText: "Date",
      border: OutlineInputBorder(),
      suffixIcon: Icon(Icons.calendar_today),
    ),
    onTap: () async {
      DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2000),
        lastDate: DateTime(2100),
      );
      if (pickedDate != null) {
        String formattedDate =
            "${pickedDate.month.toString().padLeft(2,'0')}/"
            "${pickedDate.day.toString().padLeft(2,'0')}/"
            "${pickedDate.year}";
        setState(() {
          dateController.text = formattedDate;
        });
      }
    },
  ),
  const SizedBox(height: 15),
                  /// SUBMIT BUTTON
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF4A152C),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                      ),
                      onPressed: submit,
                      child: const Text("Submit"),
                    ),
                  )
                ]),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget peoQuestion(String question, int selectedValue, Function(int) onChanged) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(question, style: TextStyle(fontWeight: FontWeight.w500)),
      SizedBox(height: 8),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(5, (index) {
          int value = index + 1;
          return InkWell(
            onTap: () => onChanged(value),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                color: selectedValue == value ? Colors.blueAccent : Colors.white,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Center(
                  child: Text(
                value.toString(),
                style: TextStyle(
                    color: selectedValue == value ? Colors.white : Colors.black,
                    fontWeight: FontWeight.bold),
              )),
            ),
          );
        }),
      ),
      SizedBox(height: 16),
    ],
  );
}

  /// 🔷 HEADER
  Widget header() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      color: Color(0xFF4A152C),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "BSIT TRACER SYSTEM",
            style: TextStyle(
              color: Colors.white,
              fontSize: 26,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 5),
          Text(
            "Graduate Tracking Form",
            style: TextStyle(color: Colors.white70),
          )
        ],
      ),
    );
  }

  /// 🔷 SECTION TITLE
  Widget sectionTitle(String title) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      padding: const EdgeInsets.all(12),
      color: Color(0xFF4A152C),
      child: Text(
        title,
        style: const TextStyle(color: Colors.white,fontWeight: FontWeight.bold),
      ),
    );
  }

  /// 🔷 CARD
  Widget sectionCard(List<Widget> children) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 5)],
      ),
      child: Column(children: children),
    );
  }

  // Helper for the questions text
Widget label(String text) {
  return Container(
    alignment: Alignment.centerLeft, // Force alignment to the left
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: Text(
      text,
      textAlign: TextAlign.left, 
      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
    ),
  );
}

// Helper for the horizontal checkbox options
Widget checkboxRow(List<String> options, String? selectedValue, Function(String) onChanged) {
  return Align(
    alignment: Alignment.centerLeft, // This pulls the group to the left
    child: Wrap(
      spacing: 20, 
      runSpacing: 10,
      children: options.map((option) {
        bool isSelected = selectedValue == option;
        return InkWell(
          onTap: () => onChanged(option),
          child: Row(
            mainAxisSize: MainAxisSize.min, 
            children: [
              Icon(
                isSelected ? Icons.check_box : Icons.check_box_outline_blank,
                size: 20, // Adjust size to match text better
                color: isSelected ? const Color(0xFF4A152C) : Colors.grey[600],
              ),
              const SizedBox(width: 6),
              Text(
                option, 
                style: const TextStyle(fontSize: 14),
              ),
            ],
          ),
        );
      }).toList(),
    ),
  );
}

  /// INPUT
  Widget input(String label, TextEditingController c,
      {bool isNumber=false,bool isEmail=false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: c,
        keyboardType: isNumber
            ? TextInputType.number
            : isEmail
                ? TextInputType.emailAddress
                : TextInputType.text,
        validator: (v){
          if(v==null||v.isEmpty)return "Required";
          if(isEmail && !v.contains("@")) return "Invalid email";
          return null;
        },
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6),
          ),
        ),
      ),
    );
  }

  /// TEXTAREA
  Widget textarea(String label, TextEditingController c){
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: c,
        maxLines: 4,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6),
          ),
        ),
      ),
    );
  }

  /// DROPDOWN
  Widget dropdown(String label, List<String> items, Function(String?) onChanged){
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: DropdownButtonFormField<String>(
        items: items.map((e)=>DropdownMenuItem(value:e,child:Text(e))).toList(),
        onChanged:(v)=>setState(()=>onChanged(v)),
        validator:(v)=>v==null?"Required":null,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6),
          ),
        ),
      ),
    );
  }

  /// SLIDER
  Widget slider(String label,double value,Function(double) onChanged,{double max=5}){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("$label (${value.round()})"),
        Slider(
          value:value,
          min:1,
          max:max,
          onChanged:(v)=>setState(()=>onChanged(v)),
        )
      ],
    );
  }

  Future<void> submit() async {
  if (!_formKey.currentState!.validate() || !isAgreed) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Please complete all required fields and consent")),
    );
    return;
  }

  if (signature.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Signature is required")),
    );
    return;
  }

  final url = Uri.parse("http://localhost/alumni_php/submit_tracer.php");

  // Convert signature to base64 string if drawn
  String? signatureBase64;
  if (signature.isNotEmpty) {
    final signatureBytes = await signature.toPngBytes();
    if (signatureBytes != null) {
      signatureBase64 = base64Encode(signatureBytes);
    }
  }

  // Prepare all PEOs
  Map<String, int> peos = {
    "peo1": peo1.toInt(),
    "peo2": peo2.toInt(),
    "peo3": peo3.toInt(),
    "peo4": peo4.toInt(),
    "peo5": peo5.toInt(),
    "peo6": peo6.toInt(),
    "peo7": peo7.toInt(),
    "peo8": peo8.toInt(),
    "peo9": peo9.toInt(),
    "peo10":peo10.toInt(),
    "peo11":peo11.toInt(),
  };

  // Prepare all satisfaction sliders
  Map<String, int> satisfaction = {
    "satisfaction1": curriculum.toInt(),
    "satisfaction2": faculty.toInt(),
    "satisfaction3": practicum.toInt(),
    "satisfaction4": resources.toInt(),
    "satisfaction5": guidance.toInt(),
    "satisfaction6": career.toInt(),
    "satisfaction7": admin.toInt(),
    "satisfaction8": overall.toInt(),
  };

 final formData = {
    "user_id": widget.userId,
    "sex": sex ?? "",
    "age": age.text, // Use .text here
    "civil_status": civil_status ?? "Single",
    "address": address.text,
    "contact": contact.text,
    "honors": honors.text,
    "preGrad": preGrad ?? "None",
    "studyMode": studyMode ?? "Regular",
    
    // Employment
    "employment": employment ?? "Unemployed",
    "unemploymentReason": unemploymentReason ?? "",
    "firstJob": firstJob ?? "",
    "firstRelated": firstRelated ?? "",
    "empType": empType ?? "",
    "jobTitle": jobTitleController.text, // Correct controller
    "company": companyController.text,   // Correct controller
    "sector": sector ?? "N/A",
    "country": (country == "Other") ? otherCountry.text : (country ?? "Philippines"),
    "income": income ?? "None",
    "jobRelated": jobRelated ?? "",
    "notRelatedReason": notRelatedReason ?? "",
    "classification": classification ?? "",

    // Skills (Questions 27 & 29)
    "skillUseRating": skillUse ?? "3", 
    "skills": skills, // This is your List<String>

    // PEOs (Mapping to match peo1, peo2... in PHP)
    "peo1": peo1.toInt(),
    "peo2": peo2.toInt(),
    "peo3": peo3.toInt(),
    "peo4": peo4.toInt(),
    "peo5": peo5.toInt(),
    "peo6": peo6.toInt(),
    "peo7": peo7.toInt(),
    "peo8": peo8.toInt(),
    "peo9": peo9.toInt(),
    "peo10":peo10.toInt(),
    "peo11":peo11.toInt(),
    for (var i = 4; i <= 11; i++) "peo$i": 0,

    // Satisfaction (Mapping to match satisfaction1, satisfaction2... in PHP)
    "satisfaction1": curriculum.toInt(),
    "satisfaction2": faculty.toInt(),
    "satisfaction3": practicum.toInt(),
    "satisfaction4": resources.toInt(),
    "satisfaction5": guidance.toInt(),
    "satisfaction6": career.toInt(),
    "satisfaction7": admin.toInt(),
    "satisfaction8": overall.toInt(),

    // Reputation & Feedback
    "recommendation": recommendation.toInt(),
    "reputation": reputation ?? "Neutral",
    "alumni": alumni ?? "No",
    "feedback1": feedback1.text,
    "feedback2": feedback2.text,
    "feedback3": feedback3.text,

    "isAgreed": isAgreed ? 1 : 0,
    "signature": signatureBase64,
  };

  try {
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(formData),
    );

    final resBody = jsonDecode(response.body);
    if (response.statusCode == 200 && resBody['status'] == 'success') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Submitted successfully!")),
      );
      Navigator.pop(context); // Go back after success
    } else {
      throw Exception(resBody['message'] ?? "Server Error");
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Error: $e")),
    );
  }
}
}