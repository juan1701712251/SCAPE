﻿using Microsoft.EntityFrameworkCore;
using SCAPE.Domain.Entities;
using SCAPE.Domain.Interfaces;
using SCAPE.Infraestructure.Context;
using System;
using System.Threading.Tasks;

namespace SCAPE.Infraestructure.Repositories
{
    public class UserRepository : IUserRepository
    {
        private readonly SCAPEDBContext _context;

        public UserRepository(SCAPEDBContext context)
        {
            _context = context;
        }

        public async Task<bool> deleteuser(string email)
        {
            User deleteUser = await _context.User.FirstOrDefaultAsync(e => e.Email == email);
            if (deleteUser != null)
            {
                _context.User.Remove(deleteUser);
                await _context.SaveChangesAsync();
                return true;
            }

            return false;
        }

        public async Task<bool> editUser(string email, string password, string role)
        {
            User editUser  = await _context.User.FirstOrDefaultAsync(e => e.Email == email);

            if(editUser != null)
            {
                editUser.Password = password;
                editUser.Role = role;
                await _context.SaveChangesAsync();

                return true;
            }

            return false;
        }

        /// <summary>
        /// Find user by email
        /// </summary>
        /// <param name="user"></param>
        /// <returns>A successful calls return a User</returns>
        public async Task<User> findUserByEmail(string email)
        {
            return await _context.User.FirstOrDefaultAsync(e => e.Email == email);
        }

        /// <summary>
        /// Find user by email and password at the context (SCAPEDB in this case)
        /// </summary>
        /// <param name="user"></param>
        /// <returns>A successful calls return a User</returns>
        public async Task<User> getUser(User user)
        {
            User userTarget = await _context.User.FirstOrDefaultAsync(e => e.Email == user.Email);
            if (userTarget == null) return null;
            return userTarget.Password == user.Password ? userTarget : null;
        }


        /// <summary>
        /// Insert User into the context (SCAPEDB in this case)
        /// </summary>
        /// <param name="user">User to insert</param>
        public async Task<bool> insertUser(User user)
        {
            _context.User.Add(user);
            await _context.SaveChangesAsync();
            return true;
        }
    }
}
