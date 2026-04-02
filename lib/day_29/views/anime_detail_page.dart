import 'package:flutter/material.dart';
import '../models/anime_model.dart';

class AnimeDetailPage extends StatelessWidget {
  final Datum anime;
  const AnimeDetailPage({super.key, required this.anime});

  String get imageUrl =>
      anime.images["jpg"]?.largeImageUrl ??
      anime.images["jpg"]?.imageUrl ??
      '';

  String get displayTitle => anime.titleEnglish ?? anime.title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F0F),
      body: CustomScrollView(
        slivers: [
          // Header dengan gambar
          SliverAppBar(
            expandedHeight: 320,
            pinned: true,
            backgroundColor: const Color(0xFF0F0F0F),
            leading: IconButton(
              icon: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.black54,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.arrow_back_ios_new,
                    color: Colors.white, size: 16),
              ),
              onPressed: () => Navigator.pop(context),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) =>
                        Container(color: Colors.grey[900]),
                  ),
                  // gradient bawah
                  Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.transparent,
                          Color(0xFF0F0F0F),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        stops: [0.5, 1.0],
                      ),
                    ),
                  ),
                  // Score badge
                  if (anime.score != null && anime.score! > 0)
                    Positioned(
                      bottom: 16,
                      right: 16,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.black87,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                              color: Colors.amber.withOpacity(0.6)),
                        ),
                        child: Row(mainAxisSize: MainAxisSize.min, children: [
                          const Icon(Icons.star_rounded,
                              color: Colors.amber, size: 16),
                          const SizedBox(width: 4),
                          Text(
                            anime.score!.toStringAsFixed(1),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(' / 10',
                              style: TextStyle(
                                  color: Colors.grey[400], fontSize: 11)),
                        ]),
                      ),
                    ),
                ],
              ),
            ),
          ),

          // Konten detail
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Judul
                  Text(
                    displayTitle,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      height: 1.2,
                    ),
                  ),
                  if (anime.titleEnglish != null &&
                      anime.titleEnglish != anime.title)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        anime.title,
                        style:
                            TextStyle(color: Colors.grey[500], fontSize: 13),
                      ),
                    ),
                  const SizedBox(height: 14),

                  // Info chips
                  Wrap(
                    spacing: 8,
                    runSpacing: 6,
                    children: [
                      _chip(
                        anime.airing ? '● Airing' : 'Finished',
                        color: anime.airing ? Colors.green : Colors.grey,
                      ),
                      if (anime.year != null) _chip('${anime.year}'),
                      if (anime.episodes != null)
                        _chip('${anime.episodes} Episodes'),
                      if (anime.duration.isNotEmpty)
                        _chip(anime.duration.replaceAll(' per ep', '')),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Synopsis
                  const Text('Synopsis',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text(
                    anime.synopsis.isNotEmpty
                        ? anime.synopsis
                        : 'No synopsis available.',
                    style: TextStyle(
                        color: Colors.grey[300],
                        fontSize: 14,
                        height: 1.6),
                  ),
                  const SizedBox(height: 24),

                  Divider(color: Colors.grey[850]),
                  const SizedBox(height: 16),

                  // Detail info
                  const Text('Details',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  _infoRow('Type', anime.type == DatumType.TV ? 'TV Series' : 'Movie'),
                  _infoRow('Status', anime.airing ? 'Currently Airing' : 'Finished Airing'),
                  _infoRow('Aired', anime.aired.string),
                  if (anime.rank != null) _infoRow('Rank', '#${anime.rank}'),
                  if (anime.popularity != null)
                    _infoRow('Popularity', '#${anime.popularity}'),
                  if (anime.members != null)
                    _infoRow('Members', _formatNumber(anime.members!)),
                  if (anime.scoredBy > 0)
                    _infoRow('Scored By', _formatNumber(anime.scoredBy)),
                  const SizedBox(height: 20),

                  // Genres
                  if (anime.genres.isNotEmpty) ...[
                    const Text('Genres',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold)),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: anime.genres.map((g) {
                        return Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 7),
                          decoration: BoxDecoration(
                            color: Colors.red.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                                color: Colors.red.withOpacity(0.4)),
                          ),
                          child: Text(g.name,
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 13)),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 20),
                  ],

                  // Studios
                  if (anime.studios.isNotEmpty) ...[
                    const Text('Studios',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 6,
                      children: anime.studios.map((s) {
                        return Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.grey[850],
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(s.name,
                              style: const TextStyle(
                                  color: Colors.white70, fontSize: 12)),
                        );
                      }).toList(),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _chip(String label, {Color color = Colors.white60}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withOpacity(0.4)),
      ),
      child: Text(label,
          style: TextStyle(
              color: color, fontSize: 11, fontWeight: FontWeight.w500)),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(label,
                style: TextStyle(color: Colors.grey[500], fontSize: 13)),
          ),
          Expanded(
            child: Text(value,
                style:
                    const TextStyle(color: Colors.white, fontSize: 13)),
          ),
        ],
      ),
    );
  }

  String _formatNumber(int n) {
    if (n >= 1000000) return '${(n / 1000000).toStringAsFixed(1)}M';
    if (n >= 1000) return '${(n / 1000).toStringAsFixed(1)}K';
    return '$n';
  }
}
