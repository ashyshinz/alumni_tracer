import 'package:flutter/material.dart';
import 'package:signature/signature.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class BSSWTracerPage extends StatefulWidget {
  final int userId;

  const BSSWTracerPage({super.key, required this.userId});

  @override
  State<BSSWTracerPage> createState() => _BSSWTracerPageState();
}

class _BSSWTracerPageState extends State<BSSWTracerPage> {
  final _formKey = GlobalKey<FormState>();

  /// CONTROLLERS
  final name = TextEditingController();
  final age = TextEditingController();
  final email = TextEditingController();
  final address = TextEditingController();
  final contact = TextEditingController();
  final honors = TextEditingController();
  final yearGraduated = TextEditingController();
  final otherCountry = TextEditingController();

  final jobTitleController = TextEditingController();
  final companyController = TextEditingController();

  final studyProgram = TextEditingController();
  final studyInstitution = TextEditingController();
  final licensureType = TextEditingController();

  final feedback1 = TextEditingController();
  final feedback2 = TextEditingController();
  final feedback3 = TextEditingController();

  TextEditingController dateController = TextEditingController();

  /// VARIABLES
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

  /// SLIDERS
  double jobSatisfaction = 1;

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
    "Casework and counseling skills",
    "Community organizing and development",
    "Social policy analysis",
    "Advocacy and networking",
    "Research and evaluation",
    "Ethical decision-making",
    "Documentation and report writing",
    "Supervision and mentoring",
    "Use of ICT tools for social work",
  ];

  @override
  void dispose() {
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

                /// HEADER
                header(),

                /// A. Graduate Profile
                sectionTitle("A. Graduate Profile"),
                input("1. Full Name", name),
                input("2. Age", age, isNumber: true),
                dropdown("3. Sex", ["Male","Female","Prefer not"], (v)=>sex=v),
                dropdown("4. Civil Status", ["Single","Married","Widowed","Separated"], (v)=>civil_status=v),
                input("5. Email", email, isEmail: true),
                input("6. Permanent Address", address),
                input("7. Contact", contact),
                input("8. Year Graduated", yearGraduated),
                input("9. Honors/Awards", honors),
                dropdown("10. Pre-graduation Experience",
                    ["None","Internship","Part-time","Full-time"], (v)=>preGrad=v),
                dropdown("11. Study Mode",
                    ["Regular","Distance/Online","Mixed"], (v)=>studyMode=v),

                /// B. Employment
                sectionTitle("B. Employment"),
                dropdown("12. Employment Status",
                    ["Employed","Self-Employed","Employer","Unemployed","Studying Full-Time"], (v){
                      setState(() {
                        employment = v;
                        if (employment != "Unemployed") unemploymentReason = null;
                      });
                    }),

                if (employment == "Unemployed") ...[
                  dropdown("13. Reason (if unemployed)",
                      ["Further study","Family/health reasons","Lack of job opportunities","Relocation","Others"],
                      (v)=>unemploymentReason=v),
                ] else if (employment != null) ...[
                  dropdown("14. First Job Time",
                      ["<1 month","1–3 months","4–6 months","7–12 months",">1 year"], (v)=>firstJob=v),
                  dropdown("15. First Job Related to Degree?",
                      ["Yes","Partly","No"], (v)=>firstRelated=v),
                  dropdown("16. Present Employment Type",
                      ["Full-time","Part-time","Project-based","Freelance"], (v)=>empType=v),
                  input("17. Job Title/Position", jobTitleController),
                  input("18. Employer/Agency/Organization", companyController),
                  dropdown("19. Sector",
                      ["Government","Private","NGO","Academic","Overseas"], (v)=>sector=v),
                  dropdown("20. Country",
                      ["Philippines","Other"], (v)=>country=v),
                  if (country == "Other") input("Specify Country", otherCountry),
                  dropdown("21. Income",
                      ["<15k","15–25k","25–35k","35–50k","50–75k",">75k"], (v)=>income=v),
                  dropdown("22. Is your current job related to social work?",
                      ["Yes","Somewhat","No"], (v)=>jobRelated=v),
                  if (jobRelated == "No")
                    dropdown("23. Reason Not Related",
                        ["No jobs in field","Better pay elsewhere","Lack of experience","Location limits","Job satisfaction in another field"],
                        (v)=>notRelatedReason=v),
                  dropdown("24. How long have you been in your current position?",
                      ["<6 months","6–12 months","1–2 years","3+ years"], (v)=>duration=v),
                  dropdown("25. Have you been promoted since your first job?", ["Yes","No"], (v)=>promoted=v),
                  dropdown("26. Would you like to work more hours than you currently do?", ["Yes","No"], (v)=>wantMore=v),
                  if (wantMore == "Yes")
                    dropdown("if yes, why?",
                        ["No available hours","Studying","Family obligations","Lack of local opportunities"],
                        (v)=>moreReason=v),
                  slider("27. Rate your overall job satisfaction:", jobSatisfaction, (v)=>setState(()=>jobSatisfaction=v)),
                ],

                /// C. Skills
                sectionTitle("C. Professional Skills and Competency Utilization"),
                label("28. How much do you use your college-acquired skills in your current job?"),
                checkboxRow(["1 Not at all","2 Slightly","3 Moderately","4 Mostly","5 Fully"], skillUse, (v)=>setState(()=>skillUse=v)),

                label("29. Do you consider yourself overqualified or underutilized for your current job?"),
                checkboxRow(["No","Slightly","Somewhat","Much","Very much"], overqualified, (v)=>setState(()=>overqualified=v)),

                label("30. Top competencies you use at work (check all)"),
                Wrap(
                  spacing: 8,
                  runSpacing: 4,
                  children: skillList.map((s) {
                    bool isSelected = skills.contains(s);
                    return InkWell(
                      onTap: () {
                        setState(() {
                          isSelected ? skills.remove(s) : skills.add(s);
                        });
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(isSelected ? Icons.check_box : Icons.check_box_outline_blank),
                          const SizedBox(width: 6),
                          Text(s)
                        ],
                      ),
                    );
                  }).toList(),
                ),

                dropdown("31. Main reason your skills might not be fully used:",
                    ["Job mismatch","No suitable jobs","Limited experience","Satisfied in current work","Financial reasons"], (v)=>{}),

                dropdown("32. Employment classification",
                    ["Rank-and-file","Supervisory","Managerial","Executive"], (v)=>classification=v),

                /// D. Further Studies
                sectionTitle("D. Further Studies, Licensure and Continuing Development"),
                dropdown("33. Are you enrolled in further studies?", ["Yes","No"], (v)=>setState(()=>furtherStudy=v)),

                if (furtherStudy == "Yes") ...[
                  input("Program", studyProgram),
                  input("Institution", studyInstitution),
                  dropdown("34. Study Type", ["Certificate","MA/MSW","PhD","Others"], (v)=>studyType=v),
                  dropdown("35. Related to Social Work", ["Yes","No"], (v)=>studyRelated=v),
                  dropdown("36. Licensure Taken", ["Yes","No"], (v)=>setState(()=>licensureTaken=v)),
                  if (licensureTaken == "Yes") ...[
                    input("Licensure Type", licensureType),
                    dropdown("Result", ["Passed","Did not pass","Pending"], (v)=>licensureResult=v),
                  ],
                  dropdown("37. CPD", ["Yes","No"], (v)=>cpd=v),
                ],

                /// E. PEOs
                sectionTitle("E. PEOs"),
                slider("38. Demonstrate knowledge, skills, and attitudes in generalist helping processes and planned change for therapeutic, protective, preventive, and transformative purposes.", peo1, (v)=>setState(()=>peo1=v)),
                slider("39. Analyze critically the origin, development, and purposes of social work in the Philippines.", peo2, (v)=>setState(()=>peo2=v)),
                slider("40. Critique the impacts of global and national socio-structural inadequacies, discrimination, and oppression on quality of life.", peo3, (v)=>setState(()=>peo3=v)),
                slider("41. Apply knowledge of human behavior and social environment emphasizing person-in-situation dynamics in assessment and intervention.", peo4, (v)=>setState(()=>peo4=v)),
                slider("42. Critique social welfare policies, programs, and services in terms of relevance, responsiveness, accessibility, and availability.", peo5, (v)=>setState(()=>peo5=v)),
                slider("43. Engage in advocacy work to promote socio-economic and cultural rights and well-being.", peo6, (v)=>setState(()=>peo6=v)),
                slider("44. Generate resources for networking and partnership development", peo7, (v)=>setState(()=>peo7=v)),
                slider("45. Identify with the social work profession and conduct oneself in accordance with social work values and ethics.", peo8, (v)=>setState(()=>peo8=v)),
                slider("46. Engage in social work practices that promote diversity and inclusion among client systems.", peo9, (v)=>setState(()=>peo9=v)),
                slider("47. Use supervision to develop critical self-reflective practice for professional growth.", peo10, (v)=>setState(()=>peo10=v)),
                slider("48. Produce and maintain portfolios, recordings, and case documentation reflecting quality practice", peo11, (v)=>setState(()=>peo11=v)),

                /// F. Satisfaction
                sectionTitle("F. Satisfaction"),
                slider("49. Curriculum relevance to social work practice", curriculum, (v)=>setState(()=>curriculum=v)),
                slider("50. Quality of faculty instruction and mentorship", faculty, (v)=>setState(()=>faculty=v)),
                slider("51. Field instruction / practicum supervision", practicum, (v)=>setState(()=>practicum=v)),
                slider("52. Library, Wi-Fi, and research resources", resources, (v)=>setState(()=>resources=v)),
                slider("53. Guidance, counseling, and student support services", guidance, (v)=>setState(()=>guidance=v)),
                slider("54. Career placement and alumni services", career, (v)=>setState(()=>career=v)),
                slider("55. Administrative services and transactions", admin, (v)=>setState(()=>admin=v)),
                slider("56. Overall satisfaction with JMCFI’s academic environment", overall, (v)=>setState(()=>overall=v)),

                /// G
                sectionTitle("G. Institutional Image and Alumni Engagement"),
                dropdown(
  "57. How would you describe JMCFI’s reputation in the IT community?",
  ["Very negative", "Negative", "Neutral", "Positive", "Very positive"],
  (v) => setState(() => reputation = v),
),
                dropdown("58. How would you describe JMCFI’s reputation in the social work community?",
                    ["Very negative","Negative","Neutral","Positive","Very positive"], (v)=>reputation=v),
                dropdown("59. Would you participate in alumni mentoring, outreach, or seminars?", ["Yes","No"], (v)=>alumni=v),

                /// H
                sectionTitle("H. Feedback and Continuous Improvement"),
                textarea("60. What specific competencies should be strengthened in the BSSW curriculum? (Open-ended)", feedback1),
                textarea("61. What aspects of field instruction need improvement? (Open-ended)", feedback2),
                textarea("62. How can JMCFI support alumni in career advancement and lifelong learning? (Open-ended)", feedback3),

                /// I
                sectionTitle("I. Consent and Data Privacy"),
                sectionCard([
                  CheckboxListTile(
                    value: isAgreed,
                    onChanged: (v)=>setState(()=>isAgreed=v!),
                    title: const Text("I voluntarily agree that my data be used for institutional QA, program review, and accreditation purposes under RA 10173 (Data Privacy Act of 2012).."),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    height: 120,
                    decoration: BoxDecoration(border: Border.all()),
                    child: Signature(controller: signature),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF4A152C),
                        foregroundColor: Colors.white,
                      ),
                      onPressed: submit,
                      child: const Text("Submit"),
                    ),
                  )
                ])
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// UI HELPERS (same structure as BSIT)

  Widget header() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      color: const Color(0xFF4A152C),
      child: const Text("BSSW TRACER SYSTEM", style: TextStyle(color: Colors.white, fontSize: 26)),
    );
  }

  Widget sectionTitle(String title) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      padding: const EdgeInsets.all(12),
      color: const Color(0xFF4A152C),
      child: Text(title, style: const TextStyle(color: Colors.white)),
    );
  }

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

  Widget input(String label, TextEditingController c,{bool isNumber=false,bool isEmail=false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: c,
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
        validator: (v){
          if(v==null||v.isEmpty)return "Required";
          if(isEmail && !v.contains("@")) return "Invalid email";
          return null;
        },
        decoration: InputDecoration(labelText: label,border: OutlineInputBorder()),
      ),
    );
  }

  Widget textarea(String label, TextEditingController c){
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: c,
        maxLines: 4,
        decoration: InputDecoration(labelText: label,border: OutlineInputBorder()),
      ),
    );
  }

  Widget dropdown(String label, List<String> items, Function(String?) onChanged){
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: DropdownButtonFormField<String>(
        items: items.map((e)=>DropdownMenuItem(value:e,child:Text(e))).toList(),
        onChanged:(v)=>setState(()=>onChanged(v)),
        validator:(v)=>v==null?"Required":null,
        decoration: InputDecoration(labelText: label,border: OutlineInputBorder()),
      ),
    );
  }

  Widget slider(String label,double value,Function(double) onChanged,{double max=5}){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("$label (${value.round()})"),
        Slider(value:value,min:1,max:max,onChanged:(v)=>setState(()=>onChanged(v)))
      ],
    );
  }

  Widget checkboxRow(List<String> options, String? selectedValue, Function(String) onChanged) {
    return Wrap(
      spacing: 20,
      runSpacing: 10,
      children: options.map((option) {
        bool isSelected = selectedValue == option;
        return InkWell(
          onTap: () => onChanged(option),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(isSelected ? Icons.check_box : Icons.check_box_outline_blank),
              const SizedBox(width: 6),
              Text(option)
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget label(String text) {
    return Container(
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(text, style: const TextStyle(fontWeight: FontWeight.bold)),
    );
  }

  /// SUBMIT (FULL LIKE BSIT)
  Future<void> submit() async {
    if (!_formKey.currentState!.validate() || !isAgreed) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Complete all fields + consent")),
      );
      return;
    }

    String? signatureBase64;
    if (signature.isNotEmpty) {
      final bytes = await signature.toPngBytes();
      if (bytes != null) signatureBase64 = base64Encode(bytes);
    }

    final url = Uri.parse("http://localhost/alumni_php/submit_tracer.php");

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

    final response = await http.post(url, headers: {"Content-Type": "application/json"}, body: jsonEncode(formData));

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Submitted successfully")));
    }
  }
}
