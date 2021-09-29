public with sharing class RandomCodeGenerator {
    public static String Generate(Integer length) {
      Blob blobKey = crypto.generateAesKey(128);
      String key = EncodingUtil.convertToHex(blobKey);
      return key.substring(0,length);
    }
}
