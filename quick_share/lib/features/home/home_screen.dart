import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../core/theme/theme_provider.dart';
import '../../core/providers/profile_provider.dart';
import '../../core/models/user_profile.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _titleController;
  late TextEditingController _urlController;
  late PageController _pageController;

  bool _isEditing = false;
  bool _isCreatingNew = false;
  String? _editingProfileId;

  @override
  void initState() {
    super.initState();
    final profileProvider = Provider.of<ProfileProvider>(context, listen: false);
    _pageController = PageController(initialPage: profileProvider.currentIndex);
    _nameController = TextEditingController();
    _titleController = TextEditingController();
    _urlController = TextEditingController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _nameController.dispose();
    _titleController.dispose();
    _urlController.dispose();
    super.dispose();
  }

  void _saveProfile() {
    if (_formKey.currentState!.validate()) {
      final profileProvider = Provider.of<ProfileProvider>(context, listen: false);
      
      final isNew = _editingProfileId == null;

      profileProvider.saveProfile(
        _editingProfileId,
        _nameController.text,
        _titleController.text,
        _urlController.text,
      );

      final newIndex = profileProvider.currentIndex;

      setState(() {
        _isEditing = false;
        _isCreatingNew = false;
        _editingProfileId = null;
      });

      // Animate PageView to the newly created/edited card
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_pageController.hasClients) {
          _pageController.jumpToPage(newIndex);
        }
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(isNew ? 'New card added successfully!' : 'Card updated successfully!'),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Theme.of(context).colorScheme.primary,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      );
    }
  }

  void _startCreating() {
    setState(() {
      _nameController.clear();
      _titleController.clear();
      _urlController.clear();
      _editingProfileId = null;
      _isCreatingNew = true;
      _isEditing = false;
    });
  }

  void _startEditing(UserProfile profile) {
    setState(() {
      _nameController.text = profile.name;
      _titleController.text = profile.title;
      _urlController.text = profile.url;
      _editingProfileId = profile.id;
      _isEditing = true;
      _isCreatingNew = false;
    });
  }

  void _cancelForm() {
    setState(() {
      _isEditing = false;
      _isCreatingNew = false;
      _editingProfileId = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final themeProvider = Provider.of<ThemeProvider>(context);
    final profileProvider = Provider.of<ProfileProvider>(context);
    final accentColor = theme.colorScheme.primary;

    final bool showForm = !profileProvider.hasProfiles || _isEditing || _isCreatingNew;

    // Synchronize page controller index with provider index if active
    if (!showForm && _pageController.hasClients && _pageController.page?.round() != profileProvider.currentIndex) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_pageController.hasClients) {
          _pageController.jumpToPage(profileProvider.currentIndex);
        }
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('QuickShare'),
        actions: [
          IconButton(
            icon: Icon(
              themeProvider.isDarkMode ? Icons.wb_sunny_rounded : Icons.nights_stay_rounded,
              color: themeProvider.isDarkMode ? Colors.amber : theme.colorScheme.primary,
            ),
            onPressed: () {
              themeProvider.toggleTheme(!themeProvider.isDarkMode);
            },
            tooltip: 'Toggle Theme',
          ),
          if (profileProvider.hasProfiles && !showForm) ...[
            IconButton(
              icon: Icon(Icons.add_circle_outline_rounded, color: accentColor),
              onPressed: _startCreating,
              tooltip: 'Generate More (Add Card)',
            ),
            IconButton(
              icon: Icon(Icons.edit_rounded, color: accentColor),
              onPressed: () {
                final current = profileProvider.currentProfile;
                if (current != null) _startEditing(current);
              },
              tooltip: 'Edit Card',
            ),
            IconButton(
              icon: const Icon(Icons.delete_outline_rounded, color: Colors.redAccent),
              onPressed: () {
                final current = profileProvider.currentProfile;
                if (current != null) _showDeleteConfirmation(context, profileProvider, current);
              },
              tooltip: 'Delete Card',
            ),
          ],
        ],
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 550),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: showForm
                    ? _buildFormView(context, theme, profileProvider)
                    : _buildCarouselView(context, theme, profileProvider),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFormView(BuildContext context, ThemeData theme, ProfileProvider provider) {
    final accentColor = theme.colorScheme.primary;
    final isEditingMode = _editingProfileId != null;

    return Card(
      key: const ValueKey('FormView'),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(28.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                isEditingMode ? 'Edit Profile Card' : 'Create Profile Card',
                style: theme.textTheme.titleLarge?.copyWith(fontSize: 22),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'Enter details below to generate an offline QR business card.',
                style: theme.textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              // Name Field
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Name',
                  prefixIcon: const Icon(Icons.person_outline_rounded),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: accentColor, width: 2),
                  ),
                ),
                textCapitalization: TextCapitalization.words,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              // Title Field
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: 'Professional Title',
                  prefixIcon: const Icon(Icons.badge_outlined),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: accentColor, width: 2),
                  ),
                ),
                textCapitalization: TextCapitalization.words,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter your title';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              // URL Field
              TextFormField(
                controller: _urlController,
                keyboardType: TextInputType.url,
                decoration: InputDecoration(
                  labelText: 'Primary URL',
                  helperText: 'e.g., github.com/username or your-portfolio.com',
                  prefixIcon: const Icon(Icons.link_rounded),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: accentColor, width: 2),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter your URL';
                  }
                  final trimmed = value.trim();
                  if (trimmed.contains(' ') || !trimmed.contains('.')) {
                    return 'Please enter a valid URL';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 28),
              // Buttons
              ElevatedButton(
                onPressed: _saveProfile,
                style: ElevatedButton.styleFrom(
                  backgroundColor: accentColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 2,
                ),
                child: Text(
                  isEditingMode ? 'Save Changes' : 'Generate QR Code',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              if (provider.hasProfiles) ...[
                const SizedBox(height: 12),
                TextButton(
                  onPressed: _cancelForm,
                  child: const Text('Cancel'),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCarouselView(BuildContext context, ThemeData theme, ProfileProvider provider) {
    final accentColor = theme.colorScheme.primary;

    return Column(
      key: const ValueKey('CarouselView'),
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Left Chevron
            Opacity(
              opacity: provider.currentIndex > 0 ? 1.0 : 0.2,
              child: IconButton(
                icon: const Icon(Icons.chevron_left_rounded, size: 36),
                onPressed: provider.currentIndex > 0
                    ? () {
                        provider.setCurrentIndex(provider.currentIndex - 1);
                      }
                    : null,
                tooltip: 'Previous Card',
              ),
            ),
            // Header showing Card Index
            Text(
              'Card ${provider.currentIndex + 1} of ${provider.profiles.length}',
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
            ),
            // Right Chevron
            Opacity(
              opacity: provider.currentIndex < provider.profiles.length - 1 ? 1.0 : 0.2,
              child: IconButton(
                icon: const Icon(Icons.chevron_right_rounded, size: 36),
                onPressed: provider.currentIndex < provider.profiles.length - 1
                    ? () {
                        provider.setCurrentIndex(provider.currentIndex + 1);
                      }
                    : null,
                tooltip: 'Next Card',
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        // Swipeable Container
        SizedBox(
          height: 480,
          child: PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              provider.setCurrentIndex(index);
            },
            itemCount: provider.profiles.length,
            itemBuilder: (context, index) {
              final profile = provider.profiles[index];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
                child: Card(
                  elevation: 6,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          radius: 32,
                          backgroundColor: accentColor.withValues(alpha: 0.1),
                          child: Icon(
                            Icons.person_rounded,
                            size: 36,
                            color: accentColor,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          profile.name,
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          profile.title,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontSize: 14,
                            letterSpacing: 0.5,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.08),
                                blurRadius: 16,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: QrImageView(
                            data: profile.url,
                            version: QrVersions.auto,
                            size: 150.0,
                            gapless: false,
                            eyeStyle: const QrEyeStyle(
                              eyeShape: QrEyeShape.square,
                              color: Color(0xFF0F172A),
                            ),
                            dataModuleStyle: const QrDataModuleStyle(
                              dataModuleShape: QrDataModuleShape.square,
                              color: Color(0xFF0F172A),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        SelectableText(
                          profile.url,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: accentColor,
                            fontWeight: FontWeight.w600,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 16),
        // Indicators (Page Dots)
        if (provider.profiles.length > 1)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              provider.profiles.length,
              (index) => AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                margin: const EdgeInsets.symmetric(horizontal: 4.0),
                height: 8.0,
                width: index == provider.currentIndex ? 24.0 : 8.0,
                decoration: BoxDecoration(
                  color: index == provider.currentIndex ? accentColor : accentColor.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(4.0),
                ),
              ),
            ),
          ),
        const SizedBox(height: 24),
        Text(
          '100% Offline • Swipe to Switch Cards',
          textAlign: TextAlign.center,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  void _showDeleteConfirmation(BuildContext context, ProfileProvider provider, UserProfile profile) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Digital Card?'),
          content: Text(
            'This will clear details for "${profile.name}" from this device.',
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              style: TextButton.styleFrom(foregroundColor: Colors.redAccent),
              child: const Text('Delete'),
              onPressed: () {
                provider.deleteProfile(profile.id);
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Card for "${profile.name}" deleted.'),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }
}
