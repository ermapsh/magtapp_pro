import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  static const List<Map<String, String>> news = [
    {
      'category': 'Technology',
      'title': 'AI is changing the way people use the internet',
      'source': 'Tech Daily',
      'time': '15 min ago',
      'image': 'https://picsum.photos/600/300?random=10',
    },
    {
      'category': 'AI',
      'title': 'New AI tools are making everyday tasks easier',
      'source': 'The Verge',
      'time': '32 min ago',
      'image': 'https://picsum.photos/600/300?random=11',
    },
    {
      'category': 'Technology',
      'title': 'The future of mobile applications is becoming more intelligent',
      'source': 'TechCrunch',
      'time': '1 hour ago',
      'image': 'https://picsum.photos/600/300?random=12',
    },
    {
      'category': 'Business',
      'title':
          'Technology companies continue investing in artificial intelligence',
      'source': 'Business Today',
      'time': '2 hours ago',
      'image': 'https://picsum.photos/600/300?random=13',
    },
    {
      'category': 'Science',
      'title': 'Scientists announce new developments in computing',
      'source': 'Science Daily',
      'time': '3 hours ago',
      'image': 'https://picsum.photos/600/300?random=14',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // Header
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'MagTapp',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      'Discover what is happening',
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.grey.shade600,
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Search
                    TextField(
                      decoration: InputDecoration(
                        hintText: 'Search the web...',
                        prefixIcon: const Icon(Icons.search),
                        filled: true,
                        fillColor: Colors.grey.shade100,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Categories
                    SizedBox(
                      height: 40,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: const [
                          _CategoryChip(label: 'For You', selected: true),
                          _CategoryChip(label: 'Technology'),
                          _CategoryChip(label: 'AI'),
                          _CategoryChip(label: 'Business'),
                          _CategoryChip(label: 'Science'),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    const Text(
                      'Latest News',
                      style: TextStyle(
                        fontSize: 21,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // News list
            SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                final article = news[index];

                return _NewsCard(
                  category: article['category']!,
                  title: article['title']!,
                  source: article['source']!,
                  time: article['time']!,
                  image: article['image']!,
                );
              }, childCount: news.length),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 30)),
          ],
        ),
      ),
    );
  }
}

class _CategoryChip extends StatelessWidget {
  final String label;
  final bool selected;

  const _CategoryChip({required this.label, this.selected = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      child: Chip(
        label: Text(label),
        backgroundColor: selected ? Colors.black : Colors.grey.shade100,
        labelStyle: TextStyle(
          color: selected ? Colors.white : Colors.black87,
          fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
        ),
        side: BorderSide.none,
        padding: const EdgeInsets.symmetric(horizontal: 8),
      ),
    );
  }
}

class _NewsCard extends StatelessWidget {
  final String category;
  final String title;
  final String source;
  final String time;
  final String image;

  const _NewsCard({
    required this.category,
    required this.title,
    required this.source,
    required this.time,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.fromLTRB(16, 6, 16, 10),
      elevation: 0,
      color: Colors.grey.shade50,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          // TODO: Open article/browser page.
        },
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Text content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      category.toUpperCase(),
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade600,
                      ),
                    ),

                    const SizedBox(height: 6),

                    Text(
                      title,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 16,
                        height: 1.3,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    const SizedBox(height: 10),

                    Row(
                      children: [
                        Text(
                          source,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          '•',
                          style: TextStyle(color: Colors.grey.shade500),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          time,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 12),

              // Thumbnail
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  image,
                  width: 110,
                  height: 90,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 110,
                      height: 90,
                      color: Colors.grey.shade200,
                      child: const Icon(Icons.image_outlined),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
