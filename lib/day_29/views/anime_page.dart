import 'dart:async';
import 'package:flutter/material.dart';
import '../services/anime_service.dart';
import '../models/anime_model.dart';
import 'anime_detail_page.dart';

class AnimePage extends StatefulWidget {
  const AnimePage({super.key});

  @override
  State<AnimePage> createState() => _AnimePageState();
}

class _AnimePageState extends State<AnimePage> {
  final AnimeService _service = AnimeService();

  List<Datum> animeList = [];
  List<Datum> filteredList = [];
  int page = 1;
  bool isLoading = false;
  bool hasMore = true;
  String? errorMessage;

  bool isSearching = false;
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final FocusNode _searchFocusNode = FocusNode(); // FIX 1: FocusNode manual

  // Carousel
  late final PageController _carouselController = PageController();
  int _carouselIndex = 0;
  Timer? _carouselTimer;

  @override
  void initState() {
    super.initState();
    fetchData();
    _scrollController.addListener(_onScroll);
    _searchController.addListener(() => _runSearch(_searchController.text));
  }

  @override
  void dispose() {
    _carouselTimer?.cancel();
    _carouselController.dispose();
    _scrollController.dispose();
    _searchController.dispose();
    _searchFocusNode.dispose(); // FIX 2: dispose FocusNode
    super.dispose();
  }

  void _startCarousel() {
    _carouselTimer?.cancel();
    _carouselTimer = Timer.periodic(const Duration(seconds: 3), (_) {
      if (!mounted || animeList.length < 5) return;
      if (!_carouselController.hasClients) return; // FIX: cek dulu sebelum animate
      final next = (_carouselIndex + 1) % 5;
      _carouselController.animateToPage(
        next,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 400 &&
        !isLoading &&
        hasMore &&
        !isSearching) {
      fetchData();
    }
  }

  Future<void> fetchData() async {
    if (isLoading) return;
    setState(() {
      isLoading = true;
      errorMessage = null;
    });
    try {
      final result = await _service.fetchAnime(page: page);
      setState(() {
        animeList.addAll(result.data);
        filteredList = List.from(animeList);
        hasMore = result.pagination.hasNextPage;
        page++;
        isLoading = false;
      });
      if (animeList.length >= 5 && _carouselTimer == null) {
        _startCarousel();
      }
    } catch (e) {
      setState(() {
        errorMessage = e.toString().replaceAll('Exception: ', '');
        isLoading = false;
      });
    }
  }

  Future<void> _refresh() async {
    _carouselTimer?.cancel();
    _carouselTimer = null;
    setState(() {
      animeList.clear();
      filteredList.clear();
      page = 1;
      hasMore = true;
      errorMessage = null;
      _carouselIndex = 0;
    });
    await fetchData();
  }

  void _runSearch(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredList = List.from(animeList);
      } else {
        final q = query.toLowerCase();
        filteredList = animeList.where((a) {
          return a.title.toLowerCase().contains(q) ||
              (a.titleEnglish?.toLowerCase().contains(q) ?? false) ||
              a.genres.any((g) => g.name.toLowerCase().contains(q));
        }).toList();
      }
    });
  }

  // FIX 3: Pisah unfocus dan setState biar gak konflik sama carousel
  void _toggleSearch() {
    if (isSearching) {
      _searchFocusNode.unfocus();
      setState(() {
        isSearching = false;
        _searchController.clear();
        filteredList = List.from(animeList);
      });
    } else {
      setState(() => isSearching = true);
      Future.delayed(const Duration(milliseconds: 150), () {
        if (mounted) _searchFocusNode.requestFocus();
      });
    }
  }

  void _goToDetail(Datum anime) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => AnimeDetailPage(anime: anime)),
    );
  }

  String _imgUrl(Datum anime, {bool large = false}) {
    final jpg = anime.images["jpg"];
    return large
        ? jpg?.largeImageUrl ?? jpg?.imageUrl ?? ''
        : jpg?.imageUrl ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      body: SafeArea(
        child: Column(
          children: [
            _buildAppBar(),
            Expanded(
              child: RefreshIndicator(
                color: Colors.red,
                backgroundColor: const Color(0xFF1A1A1A),
                onRefresh: _refresh,
                child: isSearching
                    ? _buildSearchResults()
                    : _buildMainContent(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Container(
      color: const Color(0xFF0A0A0A),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      child: Row(
        children: [
          if (!isSearching) ...[
            const SizedBox(width: 8),
            const Text(
              'ANIMAX',
              style: TextStyle(
                color: Colors.red,
                fontSize: 22,
                fontWeight: FontWeight.bold,
                letterSpacing: 4,
              ),
            ),
            const Spacer(),
          ] else ...[
            Expanded(
              child: Container(
                height: 40,
                decoration: BoxDecoration(
                  color: const Color(0xFF1E1E1E),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextField(
                  controller: _searchController,
                  focusNode: _searchFocusNode, // FIX 4: pakai FocusNode manual
                  autofocus: false,            // FIX 4: matiin autofocus
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                  cursorColor: Colors.red,
                  decoration: InputDecoration(
                    hintText: 'Cari judul, genre...',
                    hintStyle:
                        TextStyle(color: Colors.grey[600], fontSize: 14),
                    prefixIcon: const Icon(Icons.search,
                        color: Colors.grey, size: 18),
                    border: InputBorder.none,
                    contentPadding:
                        const EdgeInsets.symmetric(vertical: 10),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 4),
          ],
          IconButton(
            icon: Icon(
              isSearching ? Icons.close : Icons.search,
              color: Colors.white,
              size: 22,
            ),
            onPressed: _toggleSearch,
          ),
        ],
      ),
    );
  }

  Widget _buildMainContent() {
    if (animeList.isEmpty && isLoading) {
      return const Center(
          child: CircularProgressIndicator(color: Colors.red));
    }

    return CustomScrollView(
      controller: _scrollController,
      slivers: [
        if (errorMessage != null)
          SliverToBoxAdapter(child: _buildErrorBanner()),

        if (animeList.length >= 5)
          SliverToBoxAdapter(child: _buildCarousel()),

        if (animeList.length >= 10) ...[
          SliverToBoxAdapter(child: _sectionHeader('🔥 Trending')),
          SliverToBoxAdapter(child: _buildHorizontalRow(start: 0, end: 8)),
        ],

        if (animeList.length >= 18) ...[
          SliverToBoxAdapter(child: _sectionHeader('⭐ Populer')),
          SliverToBoxAdapter(child: _buildHorizontalRow(start: 8, end: 16)),
        ],

        SliverToBoxAdapter(child: _sectionHeader('📺 Semua Anime')),
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) => _buildAnimeCard(animeList[index]),
            childCount: animeList.length,
          ),
        ),

        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 24),
            child: Center(
              child: isLoading
                  ? const CircularProgressIndicator(color: Colors.red)
                  : !hasMore
                      ? Text('— Sudah semua —',
                          style: TextStyle(
                              color: Colors.grey[600], fontSize: 13))
                      : const SizedBox(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSearchResults() {
    if (_searchController.text.isEmpty) {
      return Center(
        child: Text('Ketik untuk mencari anime',
            style: TextStyle(color: Colors.grey[600], fontSize: 14)),
      );
    }
    if (filteredList.isEmpty) {
      return Center(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Icon(Icons.search_off, color: Colors.grey[700], size: 52),
          const SizedBox(height: 10),
          Text(
            'Tidak ada hasil untuk\n"${_searchController.text}"',
            style: TextStyle(color: Colors.grey[500], fontSize: 14),
            textAlign: TextAlign.center,
          ),
        ]),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.only(top: 8, bottom: 24),
      itemCount: filteredList.length,
      itemBuilder: (context, index) => _buildAnimeCard(filteredList[index]),
    );
  }

  Widget _buildCarousel() {
    final items = animeList.sublist(0, 5);
    return SizedBox(
      height: 420,
      child: Stack(
        children: [
          PageView.builder(
            controller: _carouselController,
            itemCount: items.length,
            onPageChanged: (i) => setState(() => _carouselIndex = i),
            itemBuilder: (_, i) => _buildCarouselSlide(items[i]),
          ),
          Positioned(
            bottom: 14,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(items.length, (i) {
                final active = i == _carouselIndex;
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  width: active ? 20 : 6,
                  height: 6,
                  decoration: BoxDecoration(
                    color: active ? Colors.red : Colors.white38,
                    borderRadius: BorderRadius.circular(3),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCarouselSlide(Datum anime) {
    return GestureDetector(
      onTap: () => _goToDetail(anime),
      child: Stack(fit: StackFit.expand, children: [
        Image.network(
          _imgUrl(anime, large: true),
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) =>
              Container(color: const Color(0xFF1A1A1A)),
        ),
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.transparent,
                Color(0x880A0A0A),
                Color(0xDD0A0A0A),
                Color(0xFF0A0A0A),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: [0.0, 0.45, 0.75, 1.0],
            ),
          ),
        ),
        Positioned(
          bottom: 36,
          left: 16,
          right: 16,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (anime.genres.isNotEmpty)
                Wrap(
                  spacing: 6,
                  children: anime.genres.take(2).map((g) => Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: Colors.red.withOpacity(0.85),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(g.name,
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold)),
                      )).toList(),
                ),
              const SizedBox(height: 8),
              Text(
                anime.titleEnglish ?? anime.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 8),
              Row(children: [
                if (anime.score != null && anime.score! > 0) ...[
                  const Icon(Icons.star_rounded,
                      color: Colors.amber, size: 15),
                  const SizedBox(width: 3),
                  Text(anime.score!.toStringAsFixed(1),
                      style: const TextStyle(
                          color: Colors.amber,
                          fontSize: 13,
                          fontWeight: FontWeight.bold)),
                  const SizedBox(width: 12),
                ],
                if (anime.episodes != null) ...[
                  Text('${anime.episodes} eps',
                      style: TextStyle(
                          color: Colors.grey[400], fontSize: 12)),
                  const SizedBox(width: 12),
                ],
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: anime.airing ? Colors.green : Colors.grey),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    anime.airing ? '● Airing' : 'Finished',
                    style: TextStyle(
                      color: anime.airing ? Colors.green : Colors.grey,
                      fontSize: 10,
                    ),
                  ),
                ),
              ]),
            ],
          ),
        ),
      ]),
    );
  }

  Widget _sectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 20, 14, 10),
      child: Text(title,
          style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildHorizontalRow({required int start, required int end}) {
    final safeEnd = end.clamp(0, animeList.length);
    if (start >= safeEnd) return const SizedBox();
    final items = animeList.sublist(start, safeEnd);

    return SizedBox(
      height: 175,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        itemCount: items.length,
        itemBuilder: (context, i) {
          final anime = items[i];
          return GestureDetector(
            onTap: () => _goToDetail(anime),
            child: Container(
              width: 110,
              margin: const EdgeInsets.only(right: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Stack(fit: StackFit.expand, children: [
                        Image.network(
                          _imgUrl(anime),
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) =>
                              Container(color: const Color(0xFF1E1E1E)),
                        ),
                        if (anime.score != null && anime.score! > 0)
                          Positioned(
                            top: 5,
                            right: 5,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 4, vertical: 2),
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.75),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(Icons.star_rounded,
                                        color: Colors.amber, size: 9),
                                    const SizedBox(width: 2),
                                    Text(anime.score!.toStringAsFixed(1),
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 9)),
                                  ]),
                            ),
                          ),
                      ]),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    anime.titleEnglish ?? anime.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                        height: 1.3),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildAnimeCard(Datum anime) {
    return GestureDetector(
      onTap: () => _goToDetail(anime),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
        decoration: BoxDecoration(
          color: const Color(0xFF161616),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(10),
                bottomLeft: Radius.circular(10),
              ),
              child: Image.network(
                _imgUrl(anime),
                width: 85,
                height: 125,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  width: 85,
                  height: 125,
                  color: const Color(0xFF1E1E1E),
                  child:
                      const Icon(Icons.image_not_supported, color: Colors.grey),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(11),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      anime.titleEnglish ?? anime.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          height: 1.3),
                    ),
                    if (anime.titleEnglish != null &&
                        anime.titleEnglish != anime.title)
                      Padding(
                        padding: const EdgeInsets.only(top: 2),
                        child: Text(
                          anime.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              color: Colors.grey[600], fontSize: 10),
                        ),
                      ),
                    const SizedBox(height: 7),
                    if (anime.score != null && anime.score! > 0)
                      Row(children: [
                        const Icon(Icons.star_rounded,
                            color: Colors.amber, size: 13),
                        const SizedBox(width: 3),
                        Text(
                          anime.score!.toStringAsFixed(1),
                          style: const TextStyle(
                              color: Colors.amber,
                              fontSize: 12,
                              fontWeight: FontWeight.bold),
                        ),
                      ]),
                    const SizedBox(height: 5),
                    Row(children: [
                      if (anime.episodes != null) ...[
                        Text('${anime.episodes} eps',
                            style: TextStyle(
                                color: Colors.grey[500], fontSize: 11)),
                        const SizedBox(width: 8),
                      ],
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 5, vertical: 2),
                        decoration: BoxDecoration(
                          color: anime.airing
                              ? Colors.green.withOpacity(0.15)
                              : Colors.transparent,
                          border: Border.all(
                            color: anime.airing
                                ? Colors.green
                                : Colors.grey[700]!,
                          ),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          anime.airing ? 'Airing' : 'Finished',
                          style: TextStyle(
                            color: anime.airing
                                ? Colors.green
                                : Colors.grey[600],
                            fontSize: 9,
                          ),
                        ),
                      ),
                    ]),
                    const SizedBox(height: 7),
                    if (anime.genres.isNotEmpty)
                      Wrap(
                        spacing: 4,
                        runSpacing: 4,
                        children: anime.genres.take(3).map((g) {
                          return Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.red.withOpacity(0.12),
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(
                                  color: Colors.red.withOpacity(0.35)),
                            ),
                            child: Text(g.name,
                                style: const TextStyle(
                                    color: Colors.white60,
                                    fontSize: 9)),
                          );
                        }).toList(),
                      ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Icon(Icons.chevron_right,
                  color: Colors.grey[700], size: 18),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorBanner() {
    return Container(
      margin: const EdgeInsets.all(12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.red[900]!.withOpacity(0.85),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(children: [
        const Icon(Icons.wifi_off, color: Colors.white, size: 18),
        const SizedBox(width: 8),
        Expanded(
            child: Text(errorMessage!,
                style:
                    const TextStyle(color: Colors.white, fontSize: 13))),
        TextButton(
          onPressed: fetchData,
          child: const Text('Retry',
              style: TextStyle(
                  color: Colors.white, fontWeight: FontWeight.bold)),
        ),
      ]),
    );
  }
}
