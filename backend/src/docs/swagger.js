
import swaggerJsdoc from 'swagger-jsdoc';

const options = {
  definition: {
    openapi: '3.0.3',
    info: {
      title: 'API Formularios – KPIs (Supabase, Realtime)',
      version: '1.0.0',
      description:
        'API modular para recibir formularios y exponer KPIs. Stack: Node + Express + Socket.IO + Supabase.',
    },
    servers: [
      { url: 'http://localhost:3000', description: 'Local' }
    ],
    components: {
      schemas: {
        RespuestaFormularioInput: {
          type: 'object',
          required: ['categoria', 'satisfaccion'],
          properties: {
            usuario_id: { type: 'string', example: 'u_01' },
            edad: { type: 'integer', example: 21 },
            genero: { type: 'string', enum: ['Masculino','Femenino','Otro'], example: 'Femenino' },
            ciudad: { type: 'string', example: 'La Paz' },
            categoria: { type: 'string', enum: ['Docentes','Infraestructura','Servicios','Administración'], example: 'Docentes' },
            satisfaccion: { type: 'integer', minimum: 1, maximum: 5, example: 5 },
            calidad_servicio: { type: 'integer', minimum: 1, maximum: 5, example: 5 },
            recomendar: { type: 'string', enum: ['Sí','No'], example: 'Sí' },
            comentario: { type: 'string', example: 'Excelente atención' },
          }
        },
        RespuestaOk: {
          type: 'object',
          properties: { ok: { type: 'boolean', example: true } }
        },
        KPIGlobal: {
          type: 'object',
          properties: {
            total: { type: 'integer', example: 37 },
            promedio: { type: 'number', format: 'float', example: 3.92 }
          }
        },
        KPICategoria: {
          type: 'object',
          properties: {
            categoria: { type: 'string', example: 'Docentes' },
            total_respuestas: { type: 'integer', example: 12 },
            promedio_satisfaccion: { type: 'number', format: 'float', example: 4.25 }
          }
        },
        KPIsResponse: {
          type: 'object',
          properties: {
            global: { $ref: '#/components/schemas/KPIGlobal' },
            categorias: {
              type: 'array',
              items: { $ref: '#/components/schemas/KPICategoria' }
            }
          }
        }
      }
    }
  },
  apis: [
    './src/routes/*.js',       // anotar endpoints en rutas
    './src/controllers/*.js'   // (opcional) anotar también aquí
  ],
};

export const swaggerSpec = swaggerJsdoc(options);
