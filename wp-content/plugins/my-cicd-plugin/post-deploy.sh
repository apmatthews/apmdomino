# Try to set this as action output
TEST_PLUGIN_VERSION=$(wp plugin get my-cicd-plugin | sed -n "/version/p" | cut -d$'\t' -f2)
echo "::set-output name=version::$TEST_PLUGIN_VERSION"
# Restore from backup
rm wp-content/plugins/my-cicd-plugin && mv wp-content/plugins/tmp/my-cicd-plugin wp-content/plugins/