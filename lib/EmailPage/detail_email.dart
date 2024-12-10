import 'package:final_essays/model/EmailResponse.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
// import 'email_response.dart';
import 'package:final_essays/model/EmailResponse.dart';
import 'email_compose.dart';

class EmailDetailPage extends StatelessWidget {
  final EmailResponse emailResponse;

  EmailDetailPage({required this.emailResponse});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(emailResponse.subject),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.archive)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.delete)),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Email title and label
            Text(
              emailResponse.subject,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                emailResponse.folder,
                style: const TextStyle(color: Colors.black54),
              ),
            ),
            const SizedBox(height: 16),

            // Sender info
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.grey,
                  child: Text(emailResponse.senderName[0].toUpperCase()),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(emailResponse.senderName,
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Text("to you",
                        style: TextStyle(color: Colors.grey[700], fontSize: 12)),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Email content
            Text(
              emailResponse.body,
              style: const TextStyle(fontSize: 16, height: 1.5),
            ),
            const SizedBox(height: 24),

            // Attachments (if any)
            if (emailResponse.attachments!.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Attachments:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: emailResponse.attachments!.map((attachment) {
                      return Chip(
                        label: Text(attachment.fileName),
                        backgroundColor: Colors.grey[200],
                        deleteIcon: const Icon(Icons.download),
                        onDeleted: () {
                          // Handle download
                        },
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 24),
                ],
              ),

            // Reply and Forward Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    // Navigate to reply (ComposeEmailForm)
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ComposeEmailForm(
                          initialDetails: EmailResponse(
                            id: emailResponse.id,
                            senderName: emailResponse.senderName,
                            senderEmail: emailResponse.senderEmail,
                            subject: 'Re: ${emailResponse.subject}',
                            body: '\n\n---\n${emailResponse.body}',
                            preview: emailResponse.preview,
                            createdAt: emailResponse.createdAt,
                            isRead: emailResponse.isRead,
                            isStarred: emailResponse.isStarred,
                            folder: emailResponse.folder,
                            labels: emailResponse.labels,
                            attachments: emailResponse.attachments,
                          ), // Prefixed subject
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[200],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  ),
                  icon: const Icon(Icons.reply, color: Colors.black),
                  label: const Text(
                    "Trả lời",
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                const SizedBox(width: 16),
                ElevatedButton.icon(
                  onPressed: () {
                    // Navigate to forward (ComposeEmailForm)
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ComposeEmailForm(
                          initialDetails: EmailResponse(
                            id: emailResponse.id,
                            senderName: emailResponse.senderName,
                            senderEmail: emailResponse.senderEmail,
                            subject: 'Fwd: ${emailResponse.subject}',
                            body: '\n\n--- Forwarded message ---\n${emailResponse.body}',
                            preview: emailResponse.preview,
                            createdAt: emailResponse.createdAt,
                            isRead: emailResponse.isRead,
                            isStarred: emailResponse.isStarred,
                            folder: emailResponse.folder,
                            labels: emailResponse.labels,
                            attachments: emailResponse.attachments,
                          ), // Prefixed subject
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[200],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  ),
                  icon: const Icon(Icons.forward, color: Colors.black),
                  label: const Text(
                    "Chuyển tiếp",
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}


// import 'package:final_essays/model/EmailResponse.dart';
// import 'package:flutter/material.dart';
// import 'email_compose.dart';

// class EmailDetailPage extends StatelessWidget {
//   // final Map<String, String> emailDetails;

//   // EmailDetailPage({required this.emailDetails});
// final EmailResponse emailResponse; EmailDetailPage({required this.emailResponse});
//   @override
//   Widget build(BuildContext context) {
//     // final String sender = emailDetails['sender'] ?? 'Unknown Sender';
//     // final String title = emailDetails['title'] ?? 'No Subject';
//     // final String content = emailDetails['content'] ?? 'No Content';
//     // final String label = emailDetails['label'] ?? 'Inbox';

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Email Details"),
//         actions: [
//           IconButton(onPressed: () {}, icon: const Icon(Icons.archive)),
//           IconButton(onPressed: () {}, icon: const Icon(Icons.delete)),
//         ],
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Email title and label
//             Text(
//               title,
//               style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 8),
//             Container(
//               padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
//               decoration: BoxDecoration(
//                 color: Colors.grey[200],
//                 borderRadius: BorderRadius.circular(12),
//               ),
//               child: Text(
//                 label,
//                 style: const TextStyle(color: Colors.black54),
//               ),
//             ),
//             const SizedBox(height: 16),

//             // Sender info
//             Row(
//               children: [
//                 CircleAvatar(
//                   backgroundColor: Colors.grey,
//                   child: Text(sender[0].toUpperCase()),
//                 ),
//                 const SizedBox(width: 12),
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(sender,
//                         style: const TextStyle(fontWeight: FontWeight.bold)),
//                     const SizedBox(height: 4),
//                     Text("to you",
//                         style:
//                             TextStyle(color: Colors.grey[700], fontSize: 12)),
//                   ],
//                 ),
//               ],
//             ),
//             const SizedBox(height: 16),

//             // Email content
//             Text(
//               content,
//               style: const TextStyle(fontSize: 16, height: 1.5),
//             ),
//             const SizedBox(height: 24),

//             // Attachments (if any)
//             if (emailDetails.containsKey('attachments'))
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const Text(
//                     'Attachments:',
//                     style: TextStyle(fontWeight: FontWeight.bold),
//                   ),
//                   const SizedBox(height: 8),
//                   Wrap(
//                     spacing: 8,
//                     runSpacing: 8,
//                     children: emailDetails['attachments']!
//                         .split(',')
//                         .map((attachment) {
//                       return Chip(
//                         label: Text(attachment),
//                         backgroundColor: Colors.grey[200],
//                         deleteIcon: const Icon(Icons.download),
//                         onDeleted: () {
//                           // Handle download
//                         },
//                       );
//                     }).toList(),
//                   ),
//                   const SizedBox(height: 24),
//                 ],
//               ),

//             // Reply and Forward Buttons
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 ElevatedButton.icon(
//                   onPressed: () {
//                     // Navigate to reply (ComposeEmailForm)
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => ComposeEmailForm(
//                             // onDraftSaved: null, // Optional for drafts
//                             // initialDetails: {
//                             //   'to': sender, // Reply to sender
//                             //   'title': 'Re: $title', // Prefixed subject
//                             //   'content': '\n\n---\n$content', // Include original message
//                             // },
//                             ),
//                       ),
//                     );
//                   },
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.grey[200],
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(20.0),
//                     ),
//                     padding: const EdgeInsets.symmetric(
//                         horizontal: 20, vertical: 12),
//                   ),
//                   icon: const Icon(Icons.reply, color: Colors.black),
//                   label: const Text(
//                     "Trả lời",
//                     style: TextStyle(color: Colors.black),
//                   ),
//                 ),
//                 const SizedBox(width: 16),
//                 ElevatedButton.icon(
//                   onPressed: () {
//                     // Navigate to forward (ComposeEmailForm)
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => ComposeEmailForm(
//                             // onDraftSaved: null, // Optional for drafts
//                             // initialDetails: {
//                             //   'title': 'Fwd: $title', // Prefixed subject
//                             //   'content': '\n\n--- Forwarded message ---\n$content', // Include original message
//                             // },
//                             ),
//                       ),
//                     );
//                   },
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.grey[200],
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(20.0),
//                     ),
//                     padding: const EdgeInsets.symmetric(
//                         horizontal: 20, vertical: 12),
//                   ),
//                   icon: const Icon(Icons.forward, color: Colors.black),
//                   label: const Text(
//                     "Chuyển tiếp",
//                     style: TextStyle(color: Colors.black),
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
