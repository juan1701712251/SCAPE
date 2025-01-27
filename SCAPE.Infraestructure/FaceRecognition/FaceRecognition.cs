﻿using Microsoft.Azure.CognitiveServices.Vision.Face;
using Microsoft.Azure.CognitiveServices.Vision.Face.Models;
using Microsoft.Extensions.Configuration;
using SCAPE.Application.Interfaces;
using SCAPE.Domain.Entities;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Configuration;
using System.IO;
using System.Threading.Tasks;

namespace SCAPE.Infraestructure.FaceRecognition
{
    public class FaceRecognition : IFaceRecognition
    {
        private IFaceClient client;
        private readonly IConfiguration _configuration;
        private string FACE_LIST_ID;

        public FaceRecognition(IConfiguration configuration)
        {
            _configuration = configuration;
            String ENDPOINT = _configuration.GetValue<string>("AzureAPI:Endpoint");
            String API_KEY = _configuration.GetValue<string>("AzureAPI:Key");
            FACE_LIST_ID = _configuration.GetValue<string>("AzureAPI:FaceListID");
            client = Authenticate(ENDPOINT, API_KEY);
        }


        /// <summary>
        ///  Call the Azure SDK  to make request in Cognitive Services and Add a face to a specified face list
        /// </summary>
        /// <param name="encodeImage">string with encoded image to detect specified image</param>
        /// <param name="faceListId">string with face list id</param>
        /// <returns>if add face is successful return string persistedId </returns>
        public async Task<string> addFaceAsync(string encodeImage, string faceListId)
        {

            Stream image = convertEncodeImageToStream(encodeImage);

            var persistedFace =  await client.FaceList.AddFaceFromStreamAsync(faceListId, image, detectionModel: DetectionModel.Detection01);

            return persistedFace.PersistedFaceId.ToString();

        }


        public async Task<bool> deleteFaceAsync(Guid persistenceFaceID)
        {
            try
            {
                await client.FaceList.DeleteFaceAsync(FACE_LIST_ID, persistenceFaceID);
            }catch(Exception ex)
            {
                return false;
            }
            return true;
        }

        /// <summary>
        /// Call the Azure SDK  to make request in Cognitive Services and detect human faces in an image
        /// </summary>
        /// <param name="encodeImage">string with encoded image to detect specified image</param>
        /// <returns>A successful call returns a Face object, if there is more
        ///  than one face in the image returns null </returns>
        public async Task<Face> detectFaceAsync(string encodeImage)
        {

            Stream image = convertEncodeImageToStream(encodeImage);

            var detectedFaces = await client.Face.DetectWithStreamAsync(image, returnFaceId: true, detectionModel: DetectionModel.Detection01, recognitionModel: RecognitionModel.Recognition03);
            
            if(detectedFaces.Count != 1)
            {
                return null;
            }

            DetectedFace face = detectedFaces[0];
            int[] faceRectangle = { face.FaceRectangle.Top, face.FaceRectangle.Left, face.FaceRectangle.Height, face.FaceRectangle.Width };

            Face newFace = new Face(face.FaceId, faceRectangle );

            return newFace;

        }
        /// <summary>
        /// Call the Azure SDK  to make request in Cognitive Services and
        /// Given query face's faceId, to search the similar-looking faces from a faceListId
        /// </summary>
        /// <param name="face">face to search in face list</param>
        /// <param name="faceListId">An existing user-specified unique candidate face list</param>
        /// <returns> A successful call returns a string the similar face represented in persistedFaceId,</returns>
        public async Task<string> findSimilar(Face face, string faceListId)
        {
            List<SimilarFace> similarFaces = null;

            try
            {
                similarFaces = (List<SimilarFace>) await client.Face.FindSimilarAsync((Guid)face.FaceId, faceListId);
            }
            catch(APIErrorException e)
            {
                if(e.Body.Error.Code.Equals("FaceListNotReady"))
                        return null;
            }

            if (similarFaces == null || similarFaces.Count != 1)
            {
                return null;
            }

            return similarFaces[0].PersistedFaceId.ToString();
        }
        /// <summary>
        /// Uses subscription key and endpoint to create a client of Azure API.
        /// </summary>
        /// <param name="endpoint">URL of Cognitive Services in Azure</param>
        /// <param name="key">the API key generated by Azure registration</param>
        /// <returns>A successful call returns a Client</returns>
        private static IFaceClient Authenticate(string endpoint, string key)
        {
            return new FaceClient(new ApiKeyServiceClientCredentials(key)) { Endpoint = endpoint };
        }

        /// <summary>
        /// Convert base64 imagen to Stream, in order to be able to send it to Azure API
        /// </summary>
        /// <param name="encodeImage">encode image in base64</param>
        /// <returns>image in format Stream</returns>
        private Stream convertEncodeImageToStream(string encodeImage)
        {
            byte[] bytesImage = Convert.FromBase64String(encodeImage);
            MemoryStream memoryStream = new MemoryStream(bytesImage);
            return memoryStream;
        }

    }
}
