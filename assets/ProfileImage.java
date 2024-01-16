class ProfileImage extends StatelessWidget {
  final double screenWidth;
  final VoidCallback onTap;
  final File? selectedImageFile;
  final String defaultImageUrl; // Tambahkan parameter defaultImageUrl

  ProfileImage({
    required this.screenWidth,
    required this.onTap,
    required this.selectedImageFile,
    required this.defaultImageUrl, // Tambahkan parameter defaultImageUrl
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: screenWidth / 3.2,
        height: screenWidth / 3.2,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          image: DecorationImage(
            fit: BoxFit.cover,
            image: selectedImageFile != null
                ? FileImage(selectedImageFile!)
                : AssetImage(defaultImageUrl), // Gunakan defaultImageUrl jika selectedImageFile null
          ),
        ),
      ),
    );
  }
}