# Get the the new plugin version and set as action output
TEST_PLUGIN_VERSION=$(wp plugin get my-cicd-plugin | sed -n "/version/p" | cut -f2)
echo "::set-output name=after_version::$TEST_PLUGIN_VERSION"

# Restore from backup
rm -rf wp-content/plugins/my-cicd-plugin && mv wp-content/plugins/tmp/my-cicd-plugin wp-content/plugins/

# Get the old plugin version and set as action output
TEST_PLUGIN_VERSION=$(wp plugin get my-cicd-plugin | sed -n "/version/p" | cut -f2)
echo "::set-output name=before_version::$TEST_PLUGIN_VERSION"