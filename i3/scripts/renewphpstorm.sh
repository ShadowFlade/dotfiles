for product in PhpStorm; do
  echo "Resetting trial period for $product"

  echo "removing evaluation key..."
  rm -rf ~/.config/JetBrains/${product}20203/eval

  # Above path not working on latest version. Fixed below
  rm -rf ~/.config/JetBrains/${product}20203/eval

  echo "removing all evlsprt properties in options.xml..."
  sed -i 's/evlsprt//' ~/.config/JetBrains/${product}20203/options/other.xml

  # Above path not working on latest version. Fixed below
  sed -i 's/evlsprt//' ~/.config/JetBrains/${product}20203/options/other.xml

  echo
done

echo "removing userPrefs files..."
rm -rf ~/.java/.userPrefs

