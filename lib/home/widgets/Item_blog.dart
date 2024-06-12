import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/blog.dart';

class ItemBlog extends StatefulWidget {
  final Blog blog;
  const ItemBlog({Key? key, required this.blog}) : super(key: key);

  @override
  _ItemBlogState createState() => _ItemBlogState();
}

class _ItemBlogState extends State<ItemBlog> {
  bool _isExpanded = false;

  String getTruncatedDescription(String description, int maxLines) {
    List<String> lines = description.split('\n');
    if (lines.length <= maxLines) {
      return description;
    } else {
      return '${lines.take(maxLines).join('\n')}. . .';
    }
  }

  @override
  Widget build(BuildContext context) {
    final String truncatedDescription = getTruncatedDescription(widget.blog.desc, 1);
    final bool isTruncated = widget.blog.desc.split('\n').length > 1;

    return GestureDetector(
      onTap: () {
        setState(() {
          _isExpanded = !_isExpanded;
        });
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 30),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.blog.title,
              style: const TextStyle(
                fontSize: 35,
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(height: 10),
            Center(
              child: widget.blog.imageUrl != null
                  ? Image.network(
                widget.blog.imageUrl!,
                width: 150,
                height: 150,
                fit: BoxFit.cover,
              )
                  : Image.network('https://camo.githubusercontent.com/de8787ccc04d7934026103e215eaa18932deb6f170923cfcb798a3e8066108ab/68747470733a2f2f73636f74742e65652f696d616765732f6e756c6c2e706e67', // Add your default asset image path here
                width: 150,
                height: 150,
                fit: BoxFit.cover,
              ),

            ),
            Text(_isExpanded ? widget.blog.desc : truncatedDescription,
            style: const TextStyle(
              fontSize: 18,
            ),),
            ///
            ///
            /// --------------------Read More button
            if (isTruncated)
              GestureDetector(
                onTap: () {
                  setState(() {
                    _isExpanded = !_isExpanded;
                  });
                },
                child: Text(
                  _isExpanded ? "Read less" : "Read more",
                  style: TextStyle(color: Theme.of(context).primaryColor),
                ),
              ),

            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(""),
                Text(
                  widget.blog.name,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(DateFormat("dd MMM yyyy hh:mm a").format(widget.blog.createdAt)),
              ],
            ),
            const SizedBox(height: 10),

          ],
        ),
      ),
    );
  }
}
