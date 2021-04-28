﻿using AutoMapper;
using Microsoft.AspNetCore.Mvc;
using SCAPE.API.ActionsModels;
using SCAPE.Application.DTOs;
using SCAPE.Application.Interfaces;
using SCAPE.Domain.Entities;
using System.Threading.Tasks;

namespace SCAPE.API.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class EmployeeController : ControllerBase
    {
        private readonly IEmployeeService _employeeService;
        private readonly IMapper _mapper;


        public EmployeeController(IEmployeeService employeeService,IMapper mapper)
        {
            _employeeService = employeeService;
            _mapper = mapper;
        }

        /// <summary>
        /// Insert a Employee from web service
        /// </summary>
        /// <param name="employeeDTO">Objecto in DTO (Data Transfer Object) Format</param>
        /// <returns>If insert is succesfull, return a "Code status 200"</returns>
        [HttpPost]
        public async Task<IActionResult> insertEmployee(EmployeeDTO employeeDTO)
        {
            Employee employee = _mapper.Map<Employee>(employeeDTO);
            await _employeeService.insertEmployee(employee);
            return Ok("Succesfull");
        }

        [HttpPost]
        [Route("AssociateImage")]
        public async Task<IActionResult> associateFace(AssociateFaceModel data)
        {
            string documentId = data.documentId;
            string encodeImage = data.encodeImage;

            bool resultAssociate =  await _employeeService.associateFace(documentId, encodeImage);

            return Ok(resultAssociate);

        }

        [HttpPost]
        [Route("GetEmployeeByImage")]
        public async Task<IActionResult> getEmployeeByFace(FindEmployeeModel data)
        {
            string encodeImage = data.encodeImage;
            string faceListId = data.faceListId;

            Employee employee = await _employeeService.getEmployeeByFace(encodeImage,faceListId);
            EmployeeDTO employeeDTO = _mapper.Map<EmployeeDTO>(employee);
            return Ok(employeeDTO);

        }

    }
}
